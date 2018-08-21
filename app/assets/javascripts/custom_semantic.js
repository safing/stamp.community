$(document).ready(function() {
  $('#stamp_range').range({
		min: 0,
		max: 100,
		start: 50,
    step: 5,
    input: '#stamp_range_input',
    onChange: function(value) {
      $('#stamp_range_display').html(value);
    }
	});
});
