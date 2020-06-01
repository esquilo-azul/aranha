# frozen_string_literal: true

require 'eac_ruby_utils/yaml'

module Aranha
  class Address < ActiveRecord::Base
    include ::EacRailsUtils::Models::InequalityQueries

    add_inequality_queries(:created_at)

    class << self
      def set_start_point(url, processor)
        start_points[url] = processor
      end

      def add_start_points
        ::Rails.logger.info("Start points: #{start_points.count}")
        start_points.each do |url, processor|
          add(url, processor)
        end
      end

      def add(url, processor, extra_data = nil)
        a = find_or_initialize_by(url: sanitize_url(url))
        a.processor = processor
        a.extra_data = extra_data.to_yaml
        a.save!
      end

      def clear_expired
        q = by_created_at_lt(Time.zone.now - 12.hours)
        Rails.logger.info("Addresses expired: #{q.count}")
        q.destroy_all
      end

      private

      def sanitize_url(url)
        if url.is_a?(Hash)
          url.to_yaml
        else
          url.to_s
        end
      end

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
        instanciate_processor.process
        self.processed_at = Time.zone.now
        save!
      end
    end

    private

    def instanciate_processor
      processor_instancier.call(*processor_instancier_arguments)
    end

    def url_to_process
      ::EacRubyUtils::Yaml.load(url)
    end

    def processor_instancier
      processor.constantize.method(:new)
    end

    def processor_instancier_arguments
      if processor_instancier_arity == 2 || processor_instancier_arity.negative?
        [url_to_process, EacRubyUtils::Yaml.load(extra_data)]
      elsif processor_instancier_arity == 1
        [processor_instancier.call(url_to_process)]
      else
        raise("#{processor}.initialize should has 1 or 2 or * arguments")
      end
    end

    def processor_instancier_arity
      processor.constantize.instance_method(:initialize).arity
    end
  end
end
