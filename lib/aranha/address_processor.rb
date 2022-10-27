# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'aranha/temporary_errors_manager'

module Aranha
  class AddressProcessor
    NETWORK_EXCEPTIONS = ::Aranha::TemporaryErrorsManager.errors

    class << self
      def network_errors
        NETWORK_EXCEPTIONS
      end

      def rescuable_error?(error)
        return true if network_errors.any? { |klass| error.is_a?(klass) }

        error.cause.present? ? network_error?(error.cause) : false
      end
    end

    enable_simple_cache
    common_constructor :address

    def successful?
      error.blank?
    end

    def rescuable_error?
      self.class.rescuable_error?(error)
    end

    private

    def error_uncached
      address.process
      nil
    rescue ::StandardError => e
      e
    end
  end
end
