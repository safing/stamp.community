(() => {
  stimulus.register("collapsible", class extends Stimulus.Controller {
    static get targets() {
      return [ 'angle', 'details' ]
    }

    toggle() {
      this.angleTarget.classList.toggle('fa-angle-down')
      this.angleTarget.classList.toggle('fa-angle-up')
      this.detailsTarget.classList.toggle('hidden')
    }
  })
})()
