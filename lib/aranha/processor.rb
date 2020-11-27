# frozen_string_literal: true

require 'net/http'
require 'httpclient'
require 'aranha/parsers/invalid_state_exception'
require 'aranha/manager'

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
      manager.log_info("Processing #{address} (Try: #{@try}/#{max_tries_s}," \
          " Unprocessed: #{unprocessed.count}/#{::Aranha::Manager.default.addresses_count})")
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
      manager.log_warn(exception)
    end

    def next_address
      unprocessed.where.not(id: not_try_ids).first
    end

    def unprocessed
      ::Aranha::Manager.default.unprocessed_addresses
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
