# frozen_string_literal: true

require 'yaml'
require 'active_support/core_ext/module/delegation'
require 'aranha/parsers/source_address/hash_http_post'
require 'aranha/parsers/source_address/http_get'
require 'aranha/parsers/source_address/file'

module Aranha
  module Parsers
    class SourceAddress
      class << self
        SUBS = [
          ::Aranha::Parsers::SourceAddress::HashHttpPost,
          ::Aranha::Parsers::SourceAddress::HttpGet,
          ::Aranha::Parsers::SourceAddress::File
        ].freeze

        def detect_sub(source)
          return source.sub if source.is_a?(self)
          SUBS.each do |sub|
            return sub.new(source) if sub.valid_source?(source)
          end
          raise "No content fetcher found for source \"#{source}\""
        end

        def deserialize(string)
          new(string =~ %r{\A[a-z]+://} ? string.strip : ::YAML.load(string))
        end

        def from_file(path)
          deserialize(::File.read(path))
        end
      end

      attr_reader :sub

      def initialize(source)
        @sub = self.class.detect_sub(source)
      end

      delegate :content, :url, to: :sub

      def to_s
        sub.url
      end

      def serialize
        sub.serialize.strip + "\n"
      end
    end
  end
end
