# frozen_string_literal: true

module Aranha
  class DefaultProcessor
    attr_reader :source_uri, :extra_data

    class << self
      def sanitize_uri(uri)
        return uri if uri.is_a?(Hash)
        unless uri.is_a?(Addressable::URI)
          uri = uri.to_s.gsub(%r{\A/}, 'file:///')
        end
        Addressable::URI.parse(uri)
      end
    end

    def initialize(source_uri, extra_data)
      @source_uri = self.class.sanitize_uri(source_uri)
      @extra_data = extra_data
    end

    def process
      raise 'Implement method process'
    end

    protected

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
