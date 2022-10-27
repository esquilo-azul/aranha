# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/gems_registry'

module Aranha
  module TemporaryErrorsManager
    GEMS_REGISTRY_MODULE_SUFFIX = 'TemporaryErrors'

    class << self
      enable_simple_cache

      # @return [Exception]
      def errors
        errors_providers.flat_map(&:errors)
      end

      # @return [Array]
      def errors_providers
        gems_registry.registered.map(&:registered_module)
      end

      private

      # @return [EacRubyUtils::GemsRegistry]
      def gems_registry_uncached
        ::EacRubyUtils::GemsRegistry.new(GEMS_REGISTRY_MODULE_SUFFIX)
      end
    end
  end
end
