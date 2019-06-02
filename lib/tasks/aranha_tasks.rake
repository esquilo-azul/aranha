# frozen_string_literal: true

namespace(:aranha) do
  task process: :environment do
    ::Aranha::Processor.new
  end

  task clear: :environment do
    Rails.logger.info("Addresses deleted: #{::Aranha::Address.destroy_all.count}")
  end

  namespace :fixtures do
    desc 'Download remote content for fixtures.'
    task download: :environment do
      ::Aranha::Fixtures::Download.new(
        prefix: ENV['PREFIX'],
        download: ENV['DOWNLOAD'].present?,
        pending: ENV['PENDING'].present?
      ).run
    end
  end
end
