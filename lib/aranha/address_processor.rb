# frozen_string_literal: true

module Aranha
  class AddressProcessor
    enable_simple_cache
    common_constructor :address

    def successful?
      error.blank?
    end

    def rescuable_error?
      ::Aranha::TemporaryErrorsManager.temporary_error?(error)
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
