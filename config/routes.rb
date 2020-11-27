# frozen_string_literal: true

Aranha::Engine.routes.draw do
  concern :active_scaffold, ActiveScaffold::Routing::Basic.new(association: true)
end
