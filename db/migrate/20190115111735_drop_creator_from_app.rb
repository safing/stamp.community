class DropCreatorFromApp < ActiveRecord::Migration[5.2]
  def up
    App.all.each do |app|
      app.create_activity(
        :create,
        owner: User.find(app.user_id),
        created_at: app.created_at,
        updated_at: app.created_at
      )
    end
    remove_column :apps, :user_id
  end

  # ONE WAY STREET - did not see the use in adding the complex down query
end
