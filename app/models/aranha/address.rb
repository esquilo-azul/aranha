# frozen_string_literal: true
module Aranha
  class Address < ActiveRecord::Base
    include ::Eac::InequalityQueries

    add_inequality_queries(:created_at)

    class << self
      def set_start_point(url, processor)
        start_points[url] = processor
      end

      def add_start_points
        start_points.each do |url, processor|
          add(url, processor)
        end
      end

      def add(url, processor)
        a = find_or_initialize_by(url: url)
        a.processor = processor
        a.save!
      end

      def clear_expired
        q = by_created_at_lt(Time.zone.now - 12.hours)
        Rails.logger.info("Addresses expired: #{q.count}")
        q.destroy_all
      end

      private

      def start_points
        @start_points ||= {}
      end
    end

    validates :url, presence: true, uniqueness: true
    validates :processor, presence: true

    scope :unprocessed, lambda {
      where(processed_at: nil)
    }

    def to_s
      "#{processor}|#{url}"
    end

    def process
      ActiveRecord::Base.transaction do
        processor.constantize.new(url).process
        self.processed_at = Time.zone.now
        save!
      end
    end
  end
end
