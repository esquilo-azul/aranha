# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'aranha/selenium/driver_factory/firefox'

module Aranha
  module Selenium
    class DriverFactory
      class << self
        def create_driver(options = {})
          new(options).create_driver
        end
      end

      attr_reader :options

      def initialize(options)
        @options = options.with_indifferent_access.freeze
      end

      def create_driver
        driver_class.new(driver_options).build
      end

      def driver_name
        (options[:driver] || default_driver_name).to_s
      end

      def driver_class
        Aranha::Selenium::DriverFactory.const_get(driver_name.classify)
      rescue NameError
        raise "Unknown Aranha Selenium driver: \"#{driver_name}\"" \
          " (Class \"Aranha::Selenium::DriverFactory::#{driver_name.classify}\" not found)"
      end

      def default_driver_name
        :firefox
      end

      def driver_options
        options.except(:driver)
      end
    end
  end
end
