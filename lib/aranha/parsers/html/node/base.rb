# frozen_string_literal: true

module Aranha
  module Parsers
    module Html
      module Node
        class Base
          attr_reader :fields

          def initialize(fields)
            @fields = fields
          end

          def parse(node)
            Hash[fields.map { |f| [f[0], parse_field(node, f[2], f[1])] }]
          end

          private

          def parse_field(node, xpath, parser_method)
            value_method = "#{parser_method}_value"
            return send(value_method, node, xpath) if respond_to?(value_method)

            raise "Method \"#{value_method}\" not found in #{self.class}"
          end
        end
      end
    end
  end
end
