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

  def total_power
    upvote_power + downvote_power
  end

  def concludable?
    total_power >= power_threshold && majority_size >= majority_threshold
  end

  def power_threshold
    @power_threshold ||= ENVProxy.required_integer('VOTABLE_POWER_THRESHOLD')
  end

  def majority_threshold
    @majority_threshold ||= ENVProxy.required_integer('VOTABLE_MAJORITY_THRESHOLD')
  end

  def majority_size
    [upvote_power, downvote_power].max / total_power.to_f * 100
  end

  def majority_type
    return :even if upvote_power == downvote_power

    upvote_power > downvote_power ? :upvoters : :downvoters
  end

  def conclude!
    if concludable?
      case majority_type
      when :upvoters
        Votable::AcceptWorker.perform_async(votable_type: self.class, votable_id: id)
      when :downvoters
        Votable::DenyWorker.perform_async(votable_type: self.class, votable_id: id)
      end
    else
      Votable::DisputeWorker.perform_async(votable_type: self.class, votable_id: id)
    end
  end
end
