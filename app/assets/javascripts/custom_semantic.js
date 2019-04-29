// https://stackoverflow.com/a/18770589/2235594
$(document).on('turbolinks:load', function() {
  $('.activating.element').popup({});
  $('.right.menu .ui.dropdown').dropdown();
});
