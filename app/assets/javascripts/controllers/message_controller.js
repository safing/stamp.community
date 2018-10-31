import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ 'flash' ]

  close(event) {
    fade(this.flashTarget, 500)
  }
}
