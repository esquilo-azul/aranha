# frozen_string_literal: true

require 'net/http'

module Aranha
  module Parsers
    class SourceAddress
      class HttpGet
        class << self
          def valid_source?(source)
            source.to_s =~ %r{\Ahttps?://}
          end
        end

        attr_reader :source

        def initialize(source)
          @source = source.to_s
        end

        def ==(other)
          self.class == other.class && source == other.source
        end

        def url
          source
        end

        def content
          content_fetch(url)
        end

        def serialize
          url
        end

        private

        def content_fetch(uri, limit = 10)
          raise 'too many HTTP redirects' if limit.zero?

          response = Net::HTTP.get_response(URI(uri))

          case response
          when Net::HTTPSuccess then
            response.body
          when Net::HTTPRedirection then
            content_fetch(response['location'], limit - 1)
          else
            response.value
          end
        end
      end
    end
  end
end
