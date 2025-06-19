# frozen_string_literal: true

require 'selenium-webdriver'

module Aranha
  module TemporaryErrors
    CORE_ERRORS = [::SocketError].freeze
    ERRNO_ERRORS = [Errno::ECONNREFUSED, ::Errno::ECONNRESET].freeze
    NET_ERRORS = [::Net::HTTPFatalError, Net::HTTPClientException, ::Net::OpenTimeout].freeze
    SELENIUM_ERRORS = [::Selenium::WebDriver::Error::TimeoutError].freeze

    ALL_ERRORS = CORE_ERRORS + ERRNO_ERRORS + NET_ERRORS + SELENIUM_ERRORS

    class << self
      def errors
        ALL_ERRORS
      end
    end
  end
end
