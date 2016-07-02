# author: -> Ali Ahmed (Software Engineer - Ruby on Rails)
# Call Back Form Cofffee
window.requestCallback = (event) ->
  event.preventDefault()
  $form = $(event.target)
  $submit_btn = $form.find("button[type='submit']")
  $submit_btn_val = $submit_btn.text()
  $.ajax {
    type: $form.attr('method')
    url: $form.attr('action')
    data: $form.serialize()
    beforeSend: ->
      $submit_btn.html '<i class=\'fa fa-circle-o-notch fa-spin\'></i> Requesting'
    success: (response) ->
      if response.status == 'ok'
        $.notify {
          icon: 'glyphicon glyphicon-ok'
          title: '<strong>Success:</strong>'
          message: response.msg
        }, type: 'success'
        $('#call_back').modal 'hide'
      else
        $.notify {
          icon: 'glyphicon glyphicon-warning-sign'
          title: '<strong>Instructions:</strong><br />'
          message: response.errors
        }, type: 'danger'
        $submit_btn.text($submit_btn_val)
    complete: ->
      $submit_btn.html "Submit"

  }, error: (response) ->
    console.log 'Something went wrong'

dismissForm = ->
  $("#call_back").on "hidden.bs.modal", ->
    $(@).find("input[type='submit']").text("Submit")
    $(@).find("input[type='text'],textarea,input[type='email'],input[type='tel']").val("")

$(document).ready ->
  dismissForm()
  dt = new Date()

  $(".time_fields").datetimepicker
    format: 'hh:mm A'

  $(".date_fields").datetimepicker
    format: 'YYYY-DD-MM'
    minDate: dt

  $(".date_fields").find("input[type='text']").val("")
