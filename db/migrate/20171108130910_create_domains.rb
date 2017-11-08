class CreateDomains < ActiveRecord::Migration[5.1]
  def change
    create_table :domains do |t|
      t.string :url
      t.references :creator, references: :users
      t.references :parent, references: :domains

      t.timestamps
    end

    add_foreign_key :domains, :domains, column: :parent_id
    add_foreign_key :domains, :users, column: :creator_id
  end
end
