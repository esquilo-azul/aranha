# frozen_string_literal: true

require 'selenium-webdriver'

module Aranha
  module Selenium
    class DriverFactory
      class << self
        DEFAULT_DOWNLOAD_DIR = '/tmp/aranha_download_dir'

        def create_driver(options = {})
          options = options.with_indifferent_access
          options[:download_dir] ||= DEFAULT_DOWNLOAD_DIR
          create_firefox_driver(options)
        end

        private

        def create_firefox_driver(options)
          ::Selenium::WebDriver.for(
            :firefox,
            options: ::Selenium::WebDriver::Firefox::Options.new(
              profile: create_firefox_profile(options)
            )
          )
        end

        def create_firefox_profile(options)
          profile = ::Selenium::WebDriver::Firefox::Profile.new
          profile['browser.download.dir'] = options[:download_dir]
          profile['browser.download.folderList'] = 2
          profile['browser.helperApps.neverAsk.saveToDisk'] = auto_download_mime_types.join(';')
          profile['pdfjs.disabled'] = true
          profile
        end

        def auto_download_mime_types
          ::File.read(::File.join(__dir__, 'auto_download_mime_types')).each_line.map(&:strip)
        end
      end
    end
  end
end
