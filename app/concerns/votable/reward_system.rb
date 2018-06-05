module Votable
  module RewardSystem
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength
    included do
      def award_creator!
        creator.update(reputation: creator.reputation + creator_prize)
      end

      def punish_creator!
        creator.update(reputation: creator.reputation + creator_penalty)
      end

      def award_downvoters!
        User.where(id: downvotes.select(:user_id))
            .update_all("reputation = reputation + #{downvoter_prize}")
      end

      def punish_downvoters!
        User.where(id: downvotes.select(:user_id))
            .update_all("reputation = reputation + #{downvoter_penalty}")
      end

      def award_upvoters!
        User.where(id: upvotes.select(:user_id))
            .update_all("reputation = reputation + #{upvoter_prize}")
      end

      def punish_upvoters!
        User.where(id: upvotes.select(:user_id))
            .update_all("reputation = reputation + #{upvoter_penalty}")
      end

      # created good stuff
      def creator_prize
        @creator_prize ||= ENVProxy.required_integer('STAMP_CREATOR_PRIZE')
      end

      # created trash
      def creator_penalty
        @creator_penalty ||= ENVProxy.required_integer('STAMP_CREATOR_PENALTY')
      end

      # upvoted good stuff
      def upvoter_prize
        @upvoter_prize ||= ENVProxy.required_integer('STAMP_UPVOTER_PRIZE')
      end

      # upvoted trash
      def upvoter_penalty
        @upvoter_penalty ||= ENVProxy.required_integer('STAMP_UPVOTER_PENALTY')
      end

      # downvoted good stuff
      def downvoter_prize
        @downvoter_prize ||= ENVProxy.required_integer('STAMP_DOWNVOTER_PRIZE')
      end

      # downvoted trash
      def downvoter_penalty
        @downvoter_penalty ||= ENVProxy.required_integer('STAMP_DOWNVOTER_PENALTY')
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
