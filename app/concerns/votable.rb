module Votable
  extend ActiveSupport::Concern

  included do
    belongs_to :creator, class_name: 'User'
    belongs_to :stampable, polymorphic: true

    has_many :votes, as: :votable
  end

  def upvotes
    votes.where(accept: true)
  end

  def downvotes
    votes.where(accept: false)
  end

  def upvote_power
    @upvote_power ||= upvotes.sum(:power)
  end

  def downvote_power
    @downvote_power ||= downvotes.sum(:power)
  end

  def award_creator!
  end

  def punish_creator!
  end

  def award_upvoters!
  end

  def punish_upvoters!
  end

  def punish_downvoters!
  end

  def award_downvoters!
  end
end
