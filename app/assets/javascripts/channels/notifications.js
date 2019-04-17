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
});
