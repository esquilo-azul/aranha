# frozen_string_literal: true

module Aranha
  class DomElementsTraverser
    module Data
      def data
        @data.dup
      end

      private

      def store(key, options = {}, &converter)
        validate(options)
        value = store_value(options, converter)
        @data[key] = value
        r = current
        skip
        r
      end

      def store_value(options, converter)
        value = if options.key?(:attribute)
                  current.attribute(options[:attribute]).value
                else
                  current.text.strip
                end
        converter ? converter.call(value) : value
      end

      def validate(options)
        return unless options.key?(:validate)
        return if match_conditions?(options[:validate])

        raise "Element does not match conditions #{options[:validate]}" \
          " (Element: |#{current}|#{current.name}|)"
      end
    end
  end
end
