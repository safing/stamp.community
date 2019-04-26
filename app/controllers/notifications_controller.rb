class NotificationsController < ApplicationController
  def read_all
    authenticate_user!
    current_user.notifications.unread.update_all(read: true)
    respond_to :js, layout: false
  end
end
