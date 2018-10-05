class AddUniqueIndexToVotes < ActiveRecord::Migration[5.1]
  def change
    add_index(:votes, [:votable_id, :votable_type, :user_id], unique: true)
  end
end
