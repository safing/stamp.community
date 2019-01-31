class UpdateActivityParamToJsonB < ActiveRecord::Migration[5.2]
  def change
    remove_column :activities, :parameters, :text
    add_column :activities, :parameters, :jsonb, null: false, default: {}
  end
end
