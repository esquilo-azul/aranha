# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'tmpdir'

module Aranha
  module Selenium
    class DriverFactory
      class Base
        DEFAULT_DOWNLOADS_DIR = ::File.join(::Dir.tmpdir, 'aranha_downloads_dir')

        attr_reader :options

        def initialize(options)
          @options = options.with_indifferent_access.freeze
        end

        def build
          raise 'Must be overrided'
        end

        def downloads_dir
          options[:downloads_dir] || DEFAULT_DOWNLOADS_DIR
        end
      end
    end
  end
end
