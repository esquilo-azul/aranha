# frozen_string_literal: true

require 'aranha/parsers/base'
require 'aranha/parsers/source_address'
require 'aranha/parsers/source_target_fixtures'

module Aranha
  module Fixtures
    class Download
      attr_reader :pending

      def initialize(options)
        @prefix = options.fetch(:prefix)
        @prefix = '' if @prefix.blank?
        @download = options.fetch(:download)
        @pending = options.fetch(:pending)
      end

      def run
        url_files.each do |f|
          Rails.logger.info(relative_path(f))
          download(url(f), target(f)) if @download
        end
      end

      private

      def url_files
        Dir["#{fixtures_root}/**/*.url"].select { |path| select_path?(path) }
      end

      def select_path?(path)
        return false unless match_prefix_pattern(path)
        !pending || !source_exist?(path)
      end

      def match_prefix_pattern(path)
        relative_path(path).start_with?(@prefix)
      end

      def fixtures_root
        Rails.root.to_s
      end

      def download(url, target)
        Rails.logger.info "Baixando \"#{url}\"..."
        File.open(target, 'wb') { |file| file.write(::Aranha::Parsers::Base.new(url).content) }
      end

      def url(file)
        ::Aranha::Parsers::SourceAddress.from_file(file)
      end

      def target(file)
        File.expand_path(File.basename(file, '.url') + '.source.html', File.dirname(file))
      end

      def relative_path(path)
        path.sub(%r{^#{Regexp.quote(fixtures_root)}/}, '')
      end

      def source_exist?(path)
        stf = ::Aranha::Parsers::SourceTargetFixtures.new(::File.dirname(path))
        stf.source_file(::File.basename(path, '.url')).present?
      end
    end
  end
end
