# frozen_string_literal: true

class AddExtraDataToAranhaAddresses < ActiveRecord::Migration
  def change
    add_column :aranha_addresses, :extra_data, :text
  end
end
