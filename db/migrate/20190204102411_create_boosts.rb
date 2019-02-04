class CreateBoosts < ActiveRecord::Migration[5.2]
  def change
    create_table :boosts do |t|
      t.references :activity, null: false
      t.references :user, null: false
      t.bigint :reputation, null: false

      t.timestamps
    end

    add_foreign_key :boosts, :users, column: :user_id
    add_foreign_key :boosts, :activities, column: :activity_id
  end
end
