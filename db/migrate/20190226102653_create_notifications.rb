class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :activity, foreign_key: true, index: true, null: false
      t.references :actor, index: true, null: false
      t.references :recipient, foreign_key: { to_table: :users }, index: true, null: false
      t.references :reference, polymorphic: true, index: true, null: false
      t.jsonb :cache, null: false, default: {}
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
