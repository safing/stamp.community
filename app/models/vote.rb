class Vote < ApplicationRecord
  include PublicActivity::Common

  before_validation :cache_users_voting_power, on: :create

  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :today, -> { where(created_at: ApplicationController.helpers.current_day_range) }
  scope :ordered, -> { order(power: :desc, created_at: :desc) }

  validates_presence_of %i[power user votable]
  validates_uniqueness_of :user_id, scope: %i[votable_id votable_type]

  def vote_type
    upvote? ? 'upvote' : 'downvote'
  end

  def upvote?
    accept
  end

  def downvote?
    !accept
  end

  def self.joins_activities
    joins(%(
      INNER JOIN activities
              ON activities.trackable_id = votes.id
             AND activities.trackable_type = 'Vote'
             AND activities.owner_id = votes.user_id
             AND activities.owner_type = 'User'
             AND activities.recipient_id = votes.votable_id
             AND activities.recipient_type = votes.votable_type
    ))
  end

  private

  def cache_users_voting_power
    self.power = user.voting_power
  end
end
