class Comment < ApplicationRecord
  include PublicActivity::Common

  # :commentable can currently only be used with stamps
  # comment.create activities caches data of stamps, so this would fail if used on another object
  # in cache config => comment_create => stampable_name is cached
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, length: { minimum: 40 }
  validates_presence_of %i[commentable content user]

  def create_activity(*args)
    activity = super(*args)

    Notification.transaction do
      # exclude the actor from receiving a notification
      recipient_ids = commentable.commenter_ids - [user_id]
      recipient_ids.each do |recipient_id|
        Notification.create(
          activity: activity,
          actor_id: user_id,
          recipient_id: recipient_id,
          reference: commentable
        )
      end
    end
    activity
  end
end
