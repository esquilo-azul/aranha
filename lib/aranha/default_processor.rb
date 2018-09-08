# frozen_string_literal: true

module Aranha
  class DefaultProcessor
    attr_reader :source_uri

    def initialize(source_uri)
      unless source_uri.is_a?(Addressable::URI)
        source_uri = source_uri.to_s.gsub(%r{\A/}, 'file:///')
      end
      @source_uri = Addressable::URI.parse(source_uri)
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
