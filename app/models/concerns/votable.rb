module Votable
  extend ActiveSupport::Concern

  class NotInProgressError < StandardError; end

  included do
    include Votable::Results

    has_many :votes, as: :votable
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
end
