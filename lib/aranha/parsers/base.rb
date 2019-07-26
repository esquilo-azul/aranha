# frozen_string_literal: true

require 'open-uri'
require 'fileutils'
require 'aranha/parsers/source_address'

module Aranha
  module Parsers
    class Base
      LOG_DIR_ENVVAR = 'ARANHA_PARSERS_LOG_DIR'

      attr_reader :source_address

      def initialize(url)
        @source_address = ::Aranha::Parsers::SourceAddress.new(url)
      end

      delegate :url, to: :source_address

      def content
        s = source_address.content
        log_content(s)
        s
      end

      private

      def log_content(content)
        path = log_file
        return unless path
        File.open(path, 'wb') { |file| file.write(content) }
      end

      def log_file
        dir = log_parsers_dir
        return nil unless dir
        f = ::File.join(dir, "#{self.class.name.parameterize}.log")
        FileUtils.mkdir_p(File.dirname(f))
        f
      end

      def log_parsers_dir
        return ENV[LOG_DIR_ENVVAR] if ENV[LOG_DIR_ENVVAR]
        return ::Rails.root.join('log', 'parsers') if rails_root_exist?
        nil
      end

      def rails_root_exist?
        klass = Module.const_get('Rails')
        return false unless klass.is_a?(Class)
        klass.respond_to?(:root)
      rescue NameError
        return false
      end
    end
  end
end
