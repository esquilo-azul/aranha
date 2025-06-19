# frozen_string_literal: true

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

      # @param error Exception
      # @return [Boolean]
      def temporary_error?(error)
        return true if errors.any? { |klass| error.is_a?(klass) }

        error.cause.present? ? temporary_error?(error.cause) : false
      end

      private

      # @return [EacRubyUtils::GemsRegistry]
      def gems_registry_uncached
        ::EacRubyUtils::GemsRegistry.new(GEMS_REGISTRY_MODULE_SUFFIX)
      end
    end
  end
end
