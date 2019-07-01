module Authenticator
  extend ActiveSupport::Concern

  included do
    before do
      error!('403 Forbidden', 403) unless authenticated
    end

    helpers do
      def authenticated
        # TODO: Find a nicer solution than this
        return true if Rails.env.test?

        env['HTTP_X_AUTH_TOKEN'].present? &&
          ApiKey.find_by(token: env['HTTP_X_AUTH_TOKEN']).present?
      end
    end
  end
end
