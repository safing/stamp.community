class CreateBoosts < ActiveRecord::Migration[5.2]
  def change
    create_table :boosts do |t|
      t.bigint :trigger_id, null: false # activity that triggered the boost, iE stamp.accept
      t.bigint :cause_id, null: false # activity that caused the boost, iE stamp.create 
      t.references :user, null: false
      t.bigint :reputation, null: false

      t.timestamps
    end

    add_foreign_key :boosts, :users, column: :user_id
    add_foreign_key :boosts, :activities, column: :trigger_id
    add_foreign_key :boosts, :activities, column: :cause_id
  end
end
