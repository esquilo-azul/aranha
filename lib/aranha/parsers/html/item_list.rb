# frozen_string_literal: true

require_relative 'base'

module Aranha
  module Parsers
    module Html
      class ItemList < Base
        def data
          count = 0
          @data ||= nokogiri.xpath(items_xpath).map do |m|
            count += 1
            node_parser.parse(m)
          end
        rescue StandardError => e
          raise StandardError, "#{e.message} (Count: #{count})"
        end

        def items_xpath
          raise "Class #{self.class} has no method \"item_xpath\". Implement it"
        end
      end
    end
  end
end
