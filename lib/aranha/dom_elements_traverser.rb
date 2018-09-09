# frozen_string_literal: true

require_dependency 'aranha/dom_elements_traverser/conditions'
require_dependency 'aranha/dom_elements_traverser/data'
require_dependency 'aranha/dom_elements_traverser/cursor'

module Aranha
  class DomElementsTraverser
    include ::Aranha::DomElementsTraverser::Conditions
    include ::Aranha::DomElementsTraverser::Cursor
    include ::Aranha::DomElementsTraverser::Data

    class << self
      def traverse(options, &block)
        new(elements_from_options(options), &block)
      end

      def empty
        new([])
      end

      private

      def elements_from_options(options)
        options = ::EacRubyUtils::OptionsConsumer.new(options)
        elements = nil
        options.consume(:children_of) { |v| elements = v.children.to_a }
        raise 'None option of [:children_of] defined' unless elements

        options.validate
        elements
      end
    end

    private

    def initialize(elements, &block)
      @elements = elements
      @index = 0
      @data = {}
      instance_eval(&block) if block
    end
  end
end
