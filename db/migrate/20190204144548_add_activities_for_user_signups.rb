class AddActivitiesForUserSignups < ActiveRecord::Migration[5.2]
  def up
    execute(%{
      INSERT INTO activities (
        key,
        owner_id,
        owner_type,
        trackable_id,
        trackable_type,
        created_at,
        updated_at
      )
      SELECT
        'user.signup',
        users.id,
        'User',
        users.id,
        'User',
        users.created_at,
        users.created_at
      FROM users
    })
  end

  def down
  end
end
