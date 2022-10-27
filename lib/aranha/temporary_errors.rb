# frozen_string_literal: true

require 'aranha/parsers/invalid_state_exception'
require 'httpclient'
require 'eac_ruby_utils/core_ext'

module Aranha
  module TemporaryErrors
    ARANHA_ERRORS = [::Aranha::Parsers::InvalidStateException].freeze
    CORE_ERRORS = [::SocketError].freeze
    ERRNO_ERRORS = [Errno::ECONNREFUSED, ::Errno::ECONNRESET].freeze
    HTTPCLIENT_ERRORS = [
      ::HTTPClient::BadResponseError,
      ::HTTPClient::ConnectTimeoutError,
      ::HTTPClient::ReceiveTimeoutError
    ].freeze
    NET_ERRORS = [::Net::HTTPFatalError, ::Net::HTTPServerException, ::Net::OpenTimeout].freeze

    ALL_ERRORS = ARANHA_ERRORS + CORE_ERRORS + ERRNO_ERRORS +
                 HTTPCLIENT_ERRORS + NET_ERRORS

    class << self
      def errors
        ALL_ERRORS
      end
    end
  end
end
