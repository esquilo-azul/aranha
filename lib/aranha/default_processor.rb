# frozen_string_literal: true

require 'addressable'
require 'eac_ruby_utils/core_ext'

module Aranha
  class DefaultProcessor
    class << self
      def sanitize_uri(uri)
        return uri if uri.is_a?(Hash)

        uri = uri.to_s.gsub(%r{\A/}, 'file:///') unless uri.is_a?(Addressable::URI)
        Addressable::URI.parse(uri)
      end
    end

    common_constructor :source_uri, :extra_data do
      self.source_uri = self.class.sanitize_uri(source_uri)
    end

    def process
      raise 'Implement method process'
    end

    def target_uri
      source_uri
    end

    def data
      @data ||= parser_class.new(target_uri).data
    end

    def parser_class
      r = self.class.name.gsub('::Processors::', '::Parsers::').constantize
      return r unless is_a?(r)

      raise "Parser can be not the process class: #{r}"
    end
  end
end
