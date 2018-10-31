(() => {
  stimulus.register("message", class extends Stimulus.Controller {
    static get targets() {
      return [ 'flash' ]
    }

    close(event) {
      fade(this.flashTarget, 500)
    }
  })
})()
