class AddConfigToLabels < ActiveRecord::Migration[5.1]
  def change
    add_column :labels, :config, :jsonb, null: false, default: {}
  end
end
