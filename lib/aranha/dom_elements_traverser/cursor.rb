# frozen_string_literal: true

require 'eac_ruby_utils/options_consumer'

module Aranha
  class DomElementsTraverser
    module Cursor
      private

      def current
        @elements[@index]
      end

      def skip
        @index += 1
      end

      def skip_until(options)
        oc = ::EacRubyUtils::OptionsConsumer.new(options)
        optional = oc.consume(:optional, false)
        while current
          break if match_conditions?(oc.left_data)

          skip
        end
        raise "No element found for conditions #{oc.left_data}" unless current || optional

        current
      end

      def skip_until_after(conditions)
        skip_until(conditions)
        skip
        current
      end

      def if_found(conditions, &block)
        marked = @index
        skip_until({ optional: true }.merge(conditions))
        if current
          instance_eval(&block) if block
        else
          @index = marked
        end
      end
    end
  end
end
