// Stimulus needs a custom syntax without webpacker / babel
// https://medium.com/cedarcode/installing-stimulus-js-in-a-rails-app-c8564ba51ea2#6bc7

//= require stimulus.umd

(() => {
  if (!("stimulus" in window)) {
    window.stimulus = Stimulus.Application.start()
  }
})()
