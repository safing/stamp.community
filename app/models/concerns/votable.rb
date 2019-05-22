module Votable
  extend ActiveSupport::Concern

  class NotInProgressError < StandardError; end

  included do
    include Votable::Results

    has_many :votes, as: :votable
    has_many :activities, class_name: 'PublicActivity::Activity', as: :trackable
  end

  def upvotes
    votes.where(accept: true)
  end

  def downvotes
    votes.where(accept: false)
  end

  def concludable?
    total_power >= ENVProxy.required_integer('VOTABLE_POWER_THRESHOLD') &&
      majority_size >= ENVProxy.required_integer('VOTABLE_MAJORITY_THRESHOLD')
  end

  def conclude!
    if concludable?
      case majority_type
      when :upvoters
        Votable::AcceptWorker.perform_async(self.class.to_s, id)
      when :downvoters
        Votable::DenyWorker.perform_async(self.class.to_s, id)
      end
    else
      Votable::DisputeWorker.perform_async(self.class.to_s, id)
    end
  end

  def conclusion_activity
    return nil if self.in_progress?
    activities.where(key: %w[stamp.accept stamp.deny stamp.dispute]).first
  end
end
