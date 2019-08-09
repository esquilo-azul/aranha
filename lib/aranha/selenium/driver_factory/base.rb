# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'tmpdir'

module Aranha
  module Selenium
    class DriverFactory
      class Base
        DEFAULT_DOWNLOADS_DIR = ::File.join(::Dir.tmpdir, 'aranha_downloads_dir')
        DEFAULT_ACCEPT_INSECURE_CERTS = false

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

        def accept_insecure_certs?
          options[:accept_insecure_certs] || DEFAULT_ACCEPT_INSECURE_CERTS
        end
      end
    end
  end
end
