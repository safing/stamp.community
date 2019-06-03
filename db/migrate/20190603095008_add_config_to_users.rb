class AddConfigToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :config, :jsonb, default: {}, null: false
  end
end
