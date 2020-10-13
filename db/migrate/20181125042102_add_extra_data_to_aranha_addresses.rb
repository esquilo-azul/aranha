# frozen_string_literal: true

class AddExtraDataToAranhaAddresses < (
    Rails.version < '5' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    add_column :aranha_addresses, :extra_data, :text
  end
end
