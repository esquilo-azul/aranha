# frozen_string_literal: true

require 'nokogiri'
require 'aranha/parsers/base'
require 'aranha/parsers/html/node/default'

module Aranha
  module Parsers
    module Html
      class Base < ::Aranha::Parsers::Base
        class << self
          def fields
            @fields ||= []
            @fields.dup
          end

          def field(name, type, xpath)
            @fields ||= []
            @fields << Field.new(name, type, xpath)
          end

          Field = Struct.new(:name, :type, :xpath)
        end

        def nokogiri
          @nokogiri ||= Nokogiri::HTML(content, &:noblanks)
        end

        protected

        def node_parser_class
          ::Aranha::Parsers::Html::Node::Default
        end

        private

        def node_parser
          @node_parser ||= node_parser_class.new(fields)
        end

        def fields
          self.class.fields.map { |f| [f.name, f.type, f.xpath] }
        end
      end
    end
  end
end
