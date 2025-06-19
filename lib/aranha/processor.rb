# frozen_string_literal: true

require 'net/http'
require 'aranha/parsers/invalid_state_exception'
require 'aranha/manager'

module Aranha
  class Processor
    DEFAULT_MAX_TRIES = 3

    attr_reader :manager

    def initialize(manager = nil)
      @manager = manager || ::Aranha::Manager.default
      @failed = {}
      @try = 0
      self.manager.init
      process_loop
      raise "Addresses failed: #{@failed.count}" if @failed.any?
    end

    private

    def process_loop
      manager.log_info("Max tries: #{max_tries_s}")
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
      manager.log_info("Processing #{address} (Try: #{@try}/#{max_tries_s}, " \
                       "Unprocessed: #{unprocessed.count}" \
                       "/#{::Aranha::Manager.default.addresses_count})")
      ap = ::Aranha::AddressProcessor.new(address)
      if ap.successful?
        @failed.delete(ap.address.id)
      else
        process_exception(ap)
      end
    end

    def process_exception(address_processor)
      raise address_processor.error unless address_processor.rescuable_error?

      @failed[address_processor.address.id] ||= 0
      @failed[address_processor.address.id] += 1
      manager.log_warn(address_processor.error)
    end

    def next_address
      unprocessed.where.not(id: not_try_ids).first
    end

    def unprocessed
      ::Aranha::Manager.default.unprocessed_addresses
    end

    def not_try_ids
      @failed.select { |_k, v| v > @try }.map { |k, _v| k }
    end

    def max_tries_s
      max_tries <= 0 ? 'INF' : max_tries
    end

    def max_tries
      @max_tries ||= begin
        r = Integer(ENV.fetch('ARANHA_MAX_TRIES', nil))
        [r, 0].max
      rescue ArgumentError, TypeError
        DEFAULT_MAX_TRIES
      end
    end
  end
end
