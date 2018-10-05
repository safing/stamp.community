class Vote < ApplicationRecord
  before_validation :cache_users_voting_power, on: :create

  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :today, -> { where(created_at: ApplicationController.helpers.current_day_range) }
  scope :ordered, -> { order(power: :desc, created_at: :desc) }

  validates_presence_of :power
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

  private

  def cache_users_voting_power
    self.power = user.voting_power
  end
end
