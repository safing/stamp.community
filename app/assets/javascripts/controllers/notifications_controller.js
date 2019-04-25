(() => {
  stimulus.register("notifications", class extends Stimulus.Controller {
    static get targets() {
      return [ 'icon', 'counter', 'menu' ]
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
            notificationsController.increaseCounter()
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

    increaseCounter() {
      var counter = parseFloat(this.counterTarget.innerText)

      if (counter == 0) {
        this.iconTarget.classList.remove('grey')
        this.iconTarget.classList.add('purple')
      }

      this.counterTarget.innerText = counter + 1
    }
  })
})()
