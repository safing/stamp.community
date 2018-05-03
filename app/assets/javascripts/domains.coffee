$ ->
  console.log('weee')
  preview = $("#preview-url")
  $('h5').on 'click', ->
    $(this).siblings('span').toggle()
