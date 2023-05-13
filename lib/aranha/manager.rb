# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Aranha
  class Manager
    acts_as_abstract

    class << self
      attr_accessor :default
    end

    def addresses_count
      raise_abstract_method(__method__)
    end

    def add_address(_uri, _processor_class, _extra_data = nil)
      raise_abstract_method(__method__)
    end

    def add_start_point(uri, processor_class, extra_data = nil)
      start_points_var << ::EacRubyUtils::Struct.new(
        uri: uri, processor_class: processor_class, extra_data: extra_data
      )
    end

    def clear_expired_addresses
      raise_abstract_method(__method__)
    end

    def init
      clear_expired_addresses
      start_points_to_addresses
    end

    def log_info(_message)
      raise_abstract_method(__method__)
    end

    def log_warn(_message)
      raise_abstract_method(__method__)
    end

    def start_points
      start_points_var.to_enum
    end

    def start_points_to_addresses
      start_points_var.each do |sp|
        add_address(sp.uri, sp.processor_class, sp.extra_data)
      end
    end

    def unprocessed_addresses
      raise_abstract_method(__method__)
    end

    private

    def start_points_var
      @start_points_var ||= []
    end
  end
end
