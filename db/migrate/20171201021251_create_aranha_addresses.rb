# frozen_string_literal: true

class CreateAranhaAddresses < (
    Rails.version < '5' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    create_table :aranha_addresses do |t|
      t.string :url
      t.string :processor
      t.timestamp :processed_at

      t.timestamps null: false
    end
  end
end
