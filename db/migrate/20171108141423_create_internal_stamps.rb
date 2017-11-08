class CreateInternalStamps < ActiveRecord::Migration[5.1]
  def change
    create_table :internal_stamps do |t|
      t.integer :upvote_count
      t.integer :downvote_count
      t.references :label, foreign_key: true
      t.references :creator, references: :users
      t.references :stampable, polymorphic: true

      t.timestamps
    end

    add_foreign_key :internal_stamps, :users, column: :creator_id
  end
end
