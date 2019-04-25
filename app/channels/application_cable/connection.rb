module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      logger.add_tags 'ActionCable'
      self.current_user = find_verified_user
      logger.add_tags "user_id: #{current_user.id}" if current_user
    end

    protected

    def find_verified_user
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
