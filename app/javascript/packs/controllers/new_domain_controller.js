import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ 'input' ]

  connect() {
    this.focusInput()
  }

  selectLabel(event) {
    this.selectedLabelTarget.innerHTML = event.target.innerHTML
    this.selectedLabelTarget.classList.remove('hidden')
    this.labelIdTarget.value = event.target.getAttribute('data-label-id')

    $('.accordion[data-controller="new-stamp"]').accordion('open', 1)
  }

  focusInput() {
    this.inputTarget.focus();
  }
}
