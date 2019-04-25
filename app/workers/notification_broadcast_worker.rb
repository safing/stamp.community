class NotificationBroadcastWorker
  include Sidekiq::Worker

  def perform(notification_id)
    notification = Notification.find(notification_id)

    NotificationsChannel.broadcast_to(
      notification.recipient,
      notification: render_notification(notification)
    )
  end

  private

  def render_notification(notification)
    ApplicationController.render(
      partial: 'notifications/notification',
      locals: { notification: notification }
    )
  end
end
