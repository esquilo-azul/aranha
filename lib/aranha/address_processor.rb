# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Aranha
  class AddressProcessor
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

    class << self
      def network_errors
        NETWORK_EXCEPTIONS
      end

      def rescuable_error?(error)
        return true if network_errors.any? { |klass| error.is_a?(klass) }

        error.cause.present? ? network_error?(error.cause) : false
      end
    end

    enable_simple_cache
    common_constructor :address

    def successful?
      error.blank?
    end

    def rescuable_error?
      self.class.rescuable_error?(error)
    end

    private

    def error_uncached
      address.process
      nil
    rescue ::StandardError => e
      e
    end
  end
end
