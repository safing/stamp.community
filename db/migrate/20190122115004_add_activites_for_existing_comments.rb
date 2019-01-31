class AddActivitesForExistingComments < ActiveRecord::Migration[5.2]
  def up
    # INNER TO OUTER:
    # subquery 3: selects all stamps who have more than 1 comment
    # subquery 2: for each stamp, select the comments max date of the stamps comments
    # subquery 1: selects all comments whose created at is in one of the timestamps
    # ↑ (this is very exact)
    # main query: insert activities for these comments

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
        'comment.create',
        comments.user_id,
        'User',
        comments.commentable_id,
        comments.commentable_type,
        comments.id,
        'Comment',
        comments.created_at,
        comments.created_at
      FROM comments
      WHERE id IN (
        SELECT id
        FROM comments
        WHERE created_at IN (
          SELECT MAX(created_at)
          FROM comments
          WHERE commentable_type = 'Stamp'
            AND commentable_id IN (
              SELECT stamps.id
              FROM comments
              LEFT JOIN stamps
                ON comments.commentable_type = 'Stamp'
                AND stamps.id = comments.commentable_id
              GROUP BY stamps.id
              HAVING COUNT (comments.commentable_id) > 1
            )
          GROUP BY(commentable_id)
        )
      )
    })
  end

  def down
  end
end
