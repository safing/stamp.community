class DeleteDataStamps < ActiveRecord::Migration[5.2]
  def change
    drop_table :data_stamps do |t|
      t.integer :upvote_count
      t.integer :downvote_count
      t.text :state
      t.binary :data
      t.references :stampable, polymorphic: true
      t.references :creator

      t.timestamps
    end
  end
end
