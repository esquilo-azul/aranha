# frozen_string_literal: true
namespace(:aranha) do
  task process: :environment do
    ::Aranha::Processor.new
  end
end
