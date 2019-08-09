# frozen_string_literal: true

require 'selenium-webdriver'
require 'aranha/selenium/driver_factory/base'

module Aranha
  module Selenium
    class DriverFactory
      class Firefox < ::Aranha::Selenium::DriverFactory::Base
        def build
          ::Selenium::WebDriver.for(
            :firefox,
            options: ::Selenium::WebDriver::Firefox::Options.new(
              profile: build_profile,
              args: build_args
            ),
            desired_capabilities: build_capabilities
          )
        end

        private

        def build_args
          r = []
          r << '-headless' if headless?
          r
        end

        def build_capabilities
          if accept_insecure_certs?
            ::Selenium::WebDriver::Remote::Capabilities.firefox(accept_insecure_certs: true)
          else
            ::Selenium::WebDriver::Remote::Capabilities.firefox
          end
        end

        def build_profile
          r = ::Selenium::WebDriver::Firefox::Profile.new
          r['browser.download.dir'] = downloads_dir
          r['browser.download.folderList'] = 2
          r['browser.helperApps.neverAsk.saveToDisk'] = auto_download_mime_types.join(';')
          r['pdfjs.disabled'] = true
          r
        end

        def auto_download_mime_types
          ::File.read(
            ::File.join(__dir__, 'firefox_auto_download_mime_types')
          ).each_line.map(&:strip)
        end
      end
    end
  end
end
