class User < ApplicationRecord
  module Relations
    extend ActiveSupport::Concern

    included do
      has_one :api_key

      has_many :comments
      has_many :domains, foreign_key: :user_id
      has_many :stamps, foreign_key: :user_id
      has_many :votes
      has_many :boosts
      has_many :activities, class_name: 'PublicActivity::Activity', as: :owner

      def domains
        Domain.where(id: activities.where(key: 'domain.create').select(:trackable_id))
      end
    end
  end
end
