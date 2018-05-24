$ ->
  $('.collapsible').on 'click', ->
    $(this).next('span').toggleClass('hidden')
    $(this).children().toggleClass('fa-angle-up').toggleClass('fa-angle-down')
