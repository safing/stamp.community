class RefactorStampToJsonb < ActiveRecord::Migration[5.2]
  def change
    add_column :stamps, :data, :jsonb, null: false, default: {}
    add_column :stamps, :type, :string, null: false, default: 'Stamp::Label'
    remove_column :stamps, :label_id, :bigint
    remove_column :stamps, :percentage, :integer
  end
end
