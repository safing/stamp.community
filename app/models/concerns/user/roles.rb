class User < ApplicationRecord
  module Roles
    extend ActiveSupport::Concern

    ROLES = %w[user moderator admin].freeze

    included do
      validates :role, inclusion: { in: ROLES }

      def moderator?
        role == 'moderator' || admin?
      end

      def admin?
        role == 'admin'
      end
    end
  end
end
