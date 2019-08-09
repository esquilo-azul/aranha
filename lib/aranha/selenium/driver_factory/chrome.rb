# frozen_string_literal: true

require 'selenium-webdriver'
require 'aranha/selenium/driver_factory/base'

module Aranha
  module Selenium
    class DriverFactory
      class Chrome < ::Aranha::Selenium::DriverFactory::Base
        def build
          ::Selenium::WebDriver.for :chrome, options: chrome_options
        end

        private

        def chrome_options
          r = ::Selenium::WebDriver::Chrome::Options.new
          r.add_argument('--ignore-certificate-errors') if accept_insecure_certs?
          r.add_argument('--headless') if headless?
          r.add_argument('--disable-popup-blocking')
          r.add_argument('--disable-translate')
          r.add_preference(:download, prompt_for_download: false, default_directory: downloads_dir)
          r
        end
      end
    end
  end
end
