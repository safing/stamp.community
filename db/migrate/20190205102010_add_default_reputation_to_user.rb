class AddDefaultReputationToUser < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :reputation, 0
  end
end
