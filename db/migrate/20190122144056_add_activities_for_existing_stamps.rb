class AddActivitiesForExistingStamps < ActiveRecord::Migration[5.2]
  def up
    execute(%{
      INSERT INTO activities (
        key,
        owner_id,
        owner_type,
        recipient_id,
        recipient_type,
        trackable_id,
        trackable_type,
        created_at,
        updated_at
      )
      SELECT
        'stamp.create',
        stamps.user_id,
        'User',
        stamps.stampable_id,
        stamps.stampable_type,
        stamps.id,
        stamps.type,
        stamps.created_at,
        stamps.created_at
      FROM stamps
    })
  end

  def down
  end
end
