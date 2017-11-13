class CreateStamps < ActiveRecord::Migration[5.1]
  def change
    create_table :stamps do |t|
      t.integer :upvote_count
      t.integer :downvote_count
      t.integer :percentage
      t.text :state
      t.references :label, foreign_key: true
      t.references :stampable, polymorphic: true
      t.references :creator

      t.timestamps
    end

    add_foreign_key :stamps, :users, column: :creator_id
  end
end
