# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'httpclient'

module Aranha
  module Parsers
    class SourceAddress
      class HashHttpPost
        class << self
          def valid_source?(source)
            source.is_a?(::Hash) && source.with_indifferent_access.key?(:url)
          end
        end

        attr_reader :source

        def initialize(source)
          @source = source.with_indifferent_access
        end

        def url
          source.fetch(:url)
        end

        def content
          HTTPClient.new.post_content(
            source[:url],
            source[:params].merge(follow_redirect: true)
          )
        end
      end
    end
  end
end
