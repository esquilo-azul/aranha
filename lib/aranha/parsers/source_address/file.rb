# frozen_string_literal: true

require 'aranha/parsers/source_address/http_get'

module Aranha
  module Parsers
    class SourceAddress
      class File < ::Aranha::Parsers::SourceAddress::HttpGet
        SCHEME = 'file://'

        class << self
          def valid_source?(source)
            source.to_s.start_with?(SCHEME + '/', '/')
          end
        end

        def initialize(source)
          super source.to_s.gsub(/\A#{Regexp.quote(SCHEME)}/, '')
        end

        def url
          "#{SCHEME}#{source}"
        end

        def content
          ::File.open(source, &:read)
        end
      end
    end
  end
end
