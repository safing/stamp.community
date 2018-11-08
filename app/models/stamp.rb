class Stamp < ApplicationRecord
  include Votable
  include Votable::State
  include Votable::Rewardable

  belongs_to :creator, class_name: 'User', foreign_key: :user_id
  belongs_to :stampable, polymorphic: true
  has_many :comments, as: :commentable, inverse_of: :commentable

  accepts_nested_attributes_for :comments

  validates_presence_of %i[comments creator stampable state type]
  validates :type, inclusion: { in: %w[Stamp::Flag Stamp::Label Stamp::Identifier] }

  # peers = stamps with the same stampable
  def peers
    stampable.stamps.where.not(id: id)
  end

  def peers?
    peers.count.positive?
  end

  # must be implemented @ each subclass
  # can describe a stronger connection than peers
  def siblings
    raise NotImplementedError
  end

  def siblings?
    siblings.count.positive?
  end

  def vote_of(user)
    @vote_of ||= votes.find_by(user_id: user.id)
  end

  # overwrites https://apidock.com/rails/ActiveRecord/Inheritance/ClassMethods/sti_name
  # because otherwise the type would just be Label - we already have a model called that
  def sti_name
    to_s
  end
end
