# frozen_string_literal: true

require_relative 'base'

module Aranha
  module Parsers
    module Html
      class Item < Base
        def data
          @data ||= node_parser.parse(item_node)
        end

        def item_node
          @item_node ||= begin
            r = item_xpath ? nokogiri.at_xpath(item_xpath) : nokogiri
            raise "Item node not found (Item xpath: #{item_xpath})" unless r
            r
          end
        end
      end
    end
  end
end
