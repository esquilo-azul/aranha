# frozen_string_literal: true
module Aranha
  class Processor
    NETWORK_EXCEPTIONS = [::HTTPClient::BadResponseError, Errno::ECONNRESET].freeze
    DEFAULT_MAX_TRIES = 3

    def initialize
      ::Aranha::Address.clear_expired
      ::Aranha::Address.add_start_points
      @failed = {}
      @try = 0
      process_loop
      raise "Addresses failed: #{@failed.count}" if @failed.any?
    end

    private

    def process_loop
      Rails.logger.info("Max tries: #{max_tries_s}")
      loop do
        break if process_next_address
      end
    end

    def process_next_address
      a = next_address
      if a
        process_address(a)
        false
      elsif @failed.any?
        @try += 1
        max_tries > 0 && @try >= max_tries
      else
        true
      end
    end

    def process_address(a)
      Rails.logger.info("Processing #{a} (Try: #{@try}/#{max_tries_s}," \
          " Unprocessed: #{unprocessed.count}/#{Aranha::Address.count})")
      begin
        a.process
        @failed.delete(a.id)
      rescue StandardError => ex
        process_exception(a, ex)
      end
    end

    def process_exception(a, ex)
      raise ex unless network_exception?(ex)
      @failed[a.id] ||= 0
      @failed[a.id] += 1
      Rails.logger.warn(ex)
    end

    def next_address
      unprocessed.where.not(id: not_try_ids).first
    end

    def unprocessed
      ::Aranha::Address.unprocessed
    end

    def network_exception?(ex)
      NETWORK_EXCEPTIONS.any? { |klass| ex.is_a?(klass) }
    end

    def not_try_ids
      @failed.select { |_k, v| v > @try }.map { |k, _v| k }
    end

    def max_tries_s
      max_tries <= 0 ? 'INF' : max_tries
    end

    def max_tries
      @max_tries ||= begin
        r = Integer(ENV['ARANHA_MAX_TRIES'])
        r <= 0 ? 0 : r
      rescue ArgumentError
        DEFAULT_MAX_TRIES
      end
    end
  end
end
