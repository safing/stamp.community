import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ 'angle', 'details' ]

  toggle() {
    this.angleTarget.classList.toggle('fa-angle-down')
    this.angleTarget.classList.toggle('fa-angle-up')
    this.detailsTarget.classList.toggle('hidden')
  }
}
