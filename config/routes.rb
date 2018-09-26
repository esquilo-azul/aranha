# frozen_string_literal: true

Aranha::Engine.routes.draw do
  resources(:addresses) { as_routes }
end
