class Stamp < ApplicationRecord
  include Votable
  include Votable::State
  include Votable::Rewardable

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates_presence_of :percentage, :state

  belongs_to :label

  def domain?
    stampable_type == 'Domain'
  end

  def domain
    stampable if domain?
  end
end
