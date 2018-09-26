# frozen_string_literal: true

require_dependency 'aranha/application_controller'

module Aranha
  class AddressesController < ApplicationController
    active_scaffold :'aranha/address' do |_conf|
    end
  end
end
