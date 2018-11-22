module Votable
  module Results
    extend ActiveSupport::Concern

    included do
      def upvote_power
        @upvote_power ||= upvotes.sum(:power)
      end

      def downvote_power
        @downvote_power ||= downvotes.sum(:power)
      end

      def total_power
        upvote_power + downvote_power
      end

      def majority_size
        [upvote_power, downvote_power].max / total_power.to_f * 100
      end

      def majority_type
        return :even if upvote_power == downvote_power

        upvote_power > downvote_power ? :upvoters : :downvoters
      end
    end
  end
end
