class User < ApplicationRecord
  module Relations
    extend ActiveSupport::Concern

    included do
      has_one :api_key

      has_many :comments
      has_many :domains, foreign_key: :user_id
      has_many :stamps, foreign_key: :user_id
      has_many :votes

      def activities
        PublicActivity::Activity.where(owner_id: self.id)
      end

      def domains
        Domain.where(id: activities.where(key: 'domain.create').select(:trackable_id))
      end
    end
  end
end
