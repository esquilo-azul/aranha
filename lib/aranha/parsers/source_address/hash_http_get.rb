# frozen_string_literal: true

require 'aranha/parsers/source_address/hash_http_post'

module Aranha
  module Parsers
    class SourceAddress
      class HashHttpGet < ::Aranha::Parsers::SourceAddress::HashHttpPost
        class << self
          def valid_source?(source)
            source.is_a?(::Hash) &&
              source.with_indifferent_access[:method].to_s.downcase.strip == 'get'
          end
        end

        def content
          HTTPClient.new.get_content(
            source[:url],
            source[:params]
          )
        end
      end
    end
  end
end
