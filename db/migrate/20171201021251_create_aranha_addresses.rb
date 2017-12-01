# frozen_string_literal: true
class CreateAranhaAddresses < ActiveRecord::Migration
  def change
    create_table :aranha_addresses do |t|
      t.string :url
      t.string :processor
      t.timestamp :processed_at

      t.timestamps null: false
    end
  end
end
