class AddBoostsForExistingSignups < ActiveRecord::Migration[5.2]
  def up
    execute(%{
      INSERT INTO boosts (
        trigger_id,
        cause_id,
        reputation,
        user_id,
        created_at,
        updated_at
      )
      SELECT
        activities.id,
        activities.id,
        1,
        activities.owner_id,
        activities.created_at,
        activities.created_at
      FROM activities
      WHERE key = 'user.signup'
    })
  end

  def down
  end
end
