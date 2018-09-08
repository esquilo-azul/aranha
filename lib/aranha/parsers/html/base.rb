# frozen_string_literal: true

require_dependency 'aranha/parsers/base'
require_dependency 'aranha/parsers/html/node/default'

module Aranha
  module Parsers
    module Html
      class Base < ::Aranha::Parsers::Base
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
      end
    end
  end
end
