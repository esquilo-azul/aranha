# frozen_string_literal: true
module Aranha
  class Address < ActiveRecord::Base
    validates :url, presence: true, uniqueness: true
    validates :processor, presence: true
  end
end
