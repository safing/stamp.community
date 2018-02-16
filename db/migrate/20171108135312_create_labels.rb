class CreateLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :labels do |t|
      t.string :name
      t.text :description
      t.references :parent, references: :labels

      t.timestamps
    end

    add_foreign_key :labels, :labels, column: :parent_id
  end
end
