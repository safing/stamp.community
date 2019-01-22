class AddActivitiesForExistingVotes < ActiveRecord::Migration[5.2]
  def up
    execute(%{
      INSERT INTO activities (
        key,
        owner_id,
        owner_type,
        parameters,
        recipient_id,
        recipient_type,
        trackable_id,
        trackable_type,
        created_at,
        updated_at
      )
      SELECT
        'vote.create',
        votes.user_id,
        'User',
        json_build_object('accept', votes.accept),
        votes.votable_id,
        votes.votable_type,
        votes.id,
        'Vote',
        votes.created_at,
        votes.created_at
      FROM votes
    })
  end

  def down
  end
end
