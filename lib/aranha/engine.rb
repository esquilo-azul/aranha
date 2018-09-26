# frozen_string_literal: true

module Aranha
  class Engine < ::Rails::Engine
    isolate_namespace Aranha

    initializer :append_migrations do |app|
      config.paths['db/migrate'].expanded.each do |expanded_path|
        app.config.paths['db/migrate'] << expanded_path
      end
    end
  end
end
