class RenameCreatorIdToUserId < ActiveRecord::Migration[5.2]
  def change
    rename_column :stamps, :creator_id, :user_id
    rename_column :data_stamps, :creator_id, :user_id
    rename_column :domains, :creator_id, :user_id
  end
end
