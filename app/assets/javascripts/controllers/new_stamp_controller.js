(() => {
  stimulus.register("new-stamp", class extends Stimulus.Controller {
    static get targets() {
      return [ 'selectedLabel', 'labelId' ]
    }

    connect() {
      var element_to_open = 0

      if (this.data.has('setLabelId')) {
        var button = document.querySelector("[data-label-id='" + this.data.get('setLabelId') + "']")

        // without the setTimeout it just won't click the button...
        setTimeout(function() {button.click()}, 150)

        element_to_open = 1
      }
      $('.accordion[data-controller="new-stamp"]').accordion('open', element_to_open)

      var initial_percentage = 50
      if (this.data.has('setPercentage')) {
        initial_percentage = this.data.get('setPercentage')
      }

      $('#stamp_percentage_slider').slider({
        min: 0,
        max: 100,
        start: initial_percentage,
        step: 5,
        input: '#stamp_percentage',
        smooth: true,
        onMove: function(value) {
          $('#stamp_percentage_display').html(value);
          $('#stamp_percentage').val(value);
        }
      });

      $('.ui.blue.tag.label').popup({
        position: 'right center'
      });
    }

    selectLabel(event) {
      this.selectedLabelTarget.innerHTML = event.target.innerHTML
      this.selectedLabelTarget.classList.remove('hidden')
      this.labelIdTarget.value = event.target.getAttribute('data-label-id')

      $('.accordion[data-controller="new-stamp"]').accordion('open', 1)
    }
  })
})()
