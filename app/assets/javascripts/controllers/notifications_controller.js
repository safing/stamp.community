(() => {
  stimulus.register("notifications", class extends Stimulus.Controller {
    static get targets() {
      return [ 'menu' ]
    }

    connect() {
      this.connectToNotificationsChannel()
    }

    connectToNotificationsChannel() {
      let notificationsController = this

      if (App.notifications == null) {
        App.notifications = App.cable.subscriptions.create('NotificationsChannel', {
          received: function(data) {
            notificationsController.appendNotification(data)
          }
        })
      }
    }

    appendNotification(data) {
      let new_notification = new DOMParser().parseFromString(
        data['notification'], 'text/html'
      ).body.firstChild;

      this.menuTarget.insertBefore(new_notification, this.menuTarget.firstChild)
    }
  })
})()
