# https://stackoverflow.com/a/18770589/2235594
$(document).on 'turbolinks:load', ->
  $('.collapsible').on 'click', ->
    $(this).next('span').toggleClass('hidden')
    $(this).children().toggleClass('fa-angle-up').toggleClass('fa-angle-down')
