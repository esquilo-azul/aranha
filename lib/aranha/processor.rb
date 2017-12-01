# frozen_string_literal: true
module Aranha
  class Processor
    def initialize
      ::Aranha::Address.clear_expired
      ::Aranha::Address.add_start_points
      loop do
        a = ::Aranha::Address.unprocessed.first
        break unless a
        Rails.logger.info("Processing #{a}")
        a.process
      end
    end
  end
end
