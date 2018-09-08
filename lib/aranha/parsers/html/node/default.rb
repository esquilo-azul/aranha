# frozen_string_literal: true

require_dependency 'aranha/parsers/html/node/base'

module Aranha
  module Parsers
    module Html
      module Node
        class Default < ::Aranha::Parsers::Html::Node::Base
          def string_value(node, xpath)
            if node.at_xpath(xpath)
              node.at_xpath(xpath).text.to_s.tr("\u00A0", ' ').strip
            else
              ''
            end
          end

          def quoted_value(node, xpath)
            s = string_value(node, xpath)
            return '' unless s

            m = /\"([^\"]+)\"/.match(s)
            return m[1] if m

            ''
          end

          def integer_value(node, xpath)
            r = string_value(node, xpath)
            return nil if r.blank?

            m = /\d+/.match(r)
            raise "Integer not found in \"#{r}\"" unless m

            m[0].to_i
          end

          def integer_optional_value(node, xpath)
            r = string_value(node, xpath)
            m = /\d+/.match(r)
            m ? m[0].to_i : nil
          end

          def float_value(node, xpath)
            parse_float(node, xpath, true)
          end

          def float_optional_value(node, xpath)
            parse_float(node, xpath, false)
          end

          def array_value(node, xpath)
            r = node.xpath(xpath).map { |n| n.text.strip }
            r.join('|')
          end

          def join_value(node, xpath)
            m = ''
            node.xpath(xpath).each do |n|
              m << n.text.strip
            end
            m
          end

          def duration_value(node, xpath)
            m = /(\d+) m/.match(join_value(node, xpath))
            m ? m[1].to_i : nil
          end

          def regxep(node, xpath, pattern)
            s = string_value(node, xpath)
            m = pattern.match(s)
            return m if m

            raise "Pattern \"#{pattern}\" not found in string \"#{s}\""
          end

          private

          def parse_float(node, xpath, required)
            s = string_value(node, xpath)
            m = /\d+(?:[\.\,](\d+))?/.match(s)
            if m
              m[0].sub(',', '.').to_f
            elsif required
              raise "Float value not found in \"#{s}\""
            end
          end
        end
      end
    end
  end
end
