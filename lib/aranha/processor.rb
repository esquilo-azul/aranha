# frozen_string_literal: true

require 'net/http'
require_dependency 'aranha/parsers/invalid_state_exception'

module Aranha
  class Processor
    ARANHA_EXCEPTIONS = [::Aranha::Parsers::InvalidStateException].freeze
    CORE_EXCEPTIONS = [::SocketError].freeze
    ERRNO_EXCEPTIONS = [Errno::ECONNREFUSED, ::Errno::ECONNRESET].freeze
    HTTPCLIENT_EXCEPTIONS = [
      ::HTTPClient::BadResponseError,
      ::HTTPClient::ConnectTimeoutError,
      ::HTTPClient::ReceiveTimeoutError
    ].freeze
    NET_EXCEPTIONS = [::Net::HTTPFatalError, ::Net::HTTPServerException, ::Net::OpenTimeout].freeze

    NETWORK_EXCEPTIONS = ARANHA_EXCEPTIONS + CORE_EXCEPTIONS + ERRNO_EXCEPTIONS +
                         HTTPCLIENT_EXCEPTIONS + NET_EXCEPTIONS

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
        max_tries.positive? && @try >= max_tries
      else
        true
      end
    end

    def process_address(address)
      Rails.logger.info("Processing #{address} (Try: #{@try}/#{max_tries_s}," \
          " Unprocessed: #{unprocessed.count}/#{Aranha::Address.count})")
      begin
        address.process
        @failed.delete(address.id)
      rescue StandardError => e
        process_exception(address, e)
      end
    end

    def process_exception(address, exception)
      raise exception unless network_exception?(exception)

      @failed[address.id] ||= 0
      @failed[address.id] += 1
      Rails.logger.warn(exception)
    end

    def next_address
      unprocessed.where.not(id: not_try_ids).first
    end

    def unprocessed
      ::Aranha::Address.unprocessed
    end

    def network_exception?(exception)
      return true if NETWORK_EXCEPTIONS.any? { |klass| exception.is_a?(klass) }
      exception.cause.present? ? network_exception?(exception.cause) : false
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
      rescue ArgumentError, TypeError
        DEFAULT_MAX_TRIES
      end
    end
  end
end
