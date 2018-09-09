# frozen_string_literal: true

module Aranha
  class DomElementsTraverser
    module Conditions
      private

      def match_conditions?(conditions)
        raise "No element (Conditions: #{conditions})" unless current

        conditions.all? { |key, value| match_condition?(key, value) }
      end

      def match_condition?(key, value)
        case key.to_sym
        when :text then match_text_condition?(value)
        when :name then match_name_condition?(value)
        else raise "Unknown key condition: (#{key})"
        end
      end

      def match_name_condition?(tag_name)
        current.name.casecmp(tag_name.to_s).zero?
      end

      def match_text_condition?(texts)
        texts = [texts.to_s] unless texts.is_a?(Array)
        texts.all? { |t| current.text.downcase.include?(t.downcase) }
      end
    end
  end
end
