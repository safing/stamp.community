class CreateApps < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'

    create_table :apps do |t|
      t.text :uuid, null: false, default: -> { "gen_random_uuid()" }
      t.string :name
      t.string :link
      t.text :description
      t.jsonb :os
      t.references :user
      t.timestamps
    end

    add_foreign_key :apps, :users
  end
end
