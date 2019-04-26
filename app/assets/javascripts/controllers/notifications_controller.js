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

    readAll() {
      let notificationsController = this
      var counter = parseFloat(this.counterTarget.innerText)

      if (counter > 0) {
        // authenticate to /notifications/read_all
        const request = new XMLHttpRequest()
        var csrf_meta = document.head.querySelector('meta[name=csrf-token]')

        request.open('POST', '/notifications/read_all', true)
        request.setRequestHeader('X-CSRF-Token', csrf_meta.getAttribute('content'))
        request.send()

        // set counter to 0 and update style
        window.setTimeout(function() {
          notificationsController.iconTarget.classList.remove('purple')
          notificationsController.iconTarget.classList.add('grey')
          notificationsController.counterTarget.innerText = 0
        }, 600)
      }
    }
  })
})()
