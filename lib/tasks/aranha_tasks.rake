# frozen_string_literal: true

namespace(:aranha) do
  task process: :environment do
    ::Aranha::Processor.new
  end

  task clear: :environment do
    Rails.logger.info("Addresses deleted: #{::Aranha::Address.destroy_all.count}")
  end
end
