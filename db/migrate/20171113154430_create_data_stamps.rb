class CreateDataStamps < ActiveRecord::Migration[5.1]
  def change
    create_table :data_stamps do |t|
      t.integer :upvote_count
      t.integer :downvote_count
      t.text :state
      t.binary :data
      t.references :stampable, polymorphic: true
      t.references :creator

      t.timestamps
    end

    add_foreign_key :data_stamps, :users, column: :creator_id
  end
end
