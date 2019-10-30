# frozen_string_literal: true

module Aranha
  class AddressesController < ::ApplicationController
    active_scaffold :'aranha/address' do |_conf|
    end
  end
end
