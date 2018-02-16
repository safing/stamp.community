class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, null: false
      t.references :user, foreign_key: true, null: false
      t.string :type, null: false
      t.integer :power, null: false

      t.timestamps
    end
  end
end
