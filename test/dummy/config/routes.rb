# frozen_string_literal: true

Rails.application.routes.draw do
  mount Aranha::Engine => '/aranha'
end
