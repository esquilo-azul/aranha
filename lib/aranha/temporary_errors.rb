# frozen_string_literal: true

require 'aranha/parsers/invalid_state_exception'
require 'aranha/parsers/source_address/fetch_content_error'
require 'eac_ruby_utils/core_ext'
require 'selenium-webdriver'

module Aranha
  module TemporaryErrors
    ARANHA_ERRORS = [::Aranha::Parsers::InvalidStateException,
                     ::Aranha::Parsers::SourceAddress::FetchContentError].freeze
    CORE_ERRORS = [::SocketError].freeze
    ERRNO_ERRORS = [Errno::ECONNREFUSED, ::Errno::ECONNRESET].freeze
    NET_ERRORS = [::Net::HTTPFatalError, ::Net::HTTPServerException, ::Net::OpenTimeout].freeze
    SELENIUM_ERRORS = [::Selenium::WebDriver::Error::TimeoutError].freeze

    ALL_ERRORS = ARANHA_ERRORS + CORE_ERRORS + ERRNO_ERRORS + NET_ERRORS + SELENIUM_ERRORS

    class << self
      def errors
        ALL_ERRORS
      end
    end
  end
end
