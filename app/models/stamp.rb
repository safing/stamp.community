class Stamp < ApplicationRecord
  include Votable
  include Votable::State
  include Votable::Rewardable

  has_many :comments, as: :commentable, inverse_of: :commentable
  accepts_nested_attributes_for :comments

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates_presence_of :percentage, :state

  belongs_to :label

  def domain?
    stampable_type == 'Domain'
  end

  def domain
    stampable if domain?
  end

  def siblings
    stampable.stamps.where.not(id: id)
  end

  def siblings?
    siblings.count > 0
  end
end
