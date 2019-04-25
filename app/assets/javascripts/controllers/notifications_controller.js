(() => {
  stimulus.register("notifications", class extends Stimulus.Controller {
    static get targets() {
      return [ 'notifications' ]
    }

    connect() {
      if (App.notifications == null) {
        connectToNotificationsChannel()
      }
    }
  })
})()

function connectToNotificationsChannel() {
  App.notifications = App.cable.subscriptions.create('NotificationsChannel', {
    initialized: function() {
      console.log('initialized')
    },

    connected: function() {
      console.log('connected')
    },

    disconnected: function() {
      console.log('disconnected')
    },

    received: function(data) {
      console.log('received')
    }
  })
}
