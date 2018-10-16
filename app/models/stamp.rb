class Stamp < ApplicationRecord
  include Votable
  include Votable::State
  include Votable::Rewardable

  has_many :comments, as: :commentable, inverse_of: :commentable
  accepts_nested_attributes_for :comments

  validates_presence_of %i[comments creator stampable state type]
  validates :type, inclusion: { in: %w[Stamp::Label] }

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
