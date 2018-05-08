class Vote < ApplicationRecord
  before_validation :cache_users_voting_power, on: :create

  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :today, -> { where(created_at: ApplicationController.helpers.current_day_range) }

  validates_presence_of :power

  private

  def cache_users_voting_power
    self.power = user.voting_power
  end
end
