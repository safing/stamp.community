class CreateLicences < ActiveRecord::Migration[5.1]
  def change
    create_table :licences do |t|
      t.text :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
