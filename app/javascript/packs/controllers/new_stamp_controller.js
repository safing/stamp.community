import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ 'selectedLabel', 'labelId' ]

  connect() {
    var initial_percentage = 50

    if (this.data.has('setLabelId')) {
      var button = document.querySelector("[data-label-id='" + this.data.get('setLabelId') + "']")
      button.click()

      if (this.data.has('setPercentage')) {
        initial_percentage = this.data.get('setPercentage')
      }
    }
    else {
      $('.accordion[data-controller="new-stamp"]').accordion('open', 0)
    }

    $('#stamp_percentage_range').range({
      min: 0,
      max: 100,
      start: initial_percentage,
      step: 5,
      input: '#stamp_percentage',
      onChange: function(value) {
        $('#stamp_percentage_display').html(value);
      }
    });
  }

  selectLabel(event) {
    this.selectedLabelTarget.innerHTML = event.target.innerHTML
    this.selectedLabelTarget.classList.remove('hidden')
    this.labelIdTarget.value = event.target.getAttribute('data-label-id')

    $('.accordion[data-controller="new-stamp"]').accordion('open', 1)
  }
}
