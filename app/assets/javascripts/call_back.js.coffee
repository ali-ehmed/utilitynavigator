window.requestCallback = (event) ->
	event.preventDefault()
	$form = $(event.target)
	$.ajax
    type: $form.attr("method")
    url: $form.attr("action")
    data: $form.serialize()
    success: (response) ->
      if response.status == "ok"
      	$.notify {
          icon: 'glyphicon glyphicon-ok'
          title: '<strong>Success:</strong>'
          message: response.msg
        }, type: 'success'
       $("#call_back").modal("hide")
      else
      	$.notify {
          icon: 'glyphicon glyphicon-warning-sign'
          title: '<strong>Instructions:</strong><br />'
          message: response.errors
        }, type: 'danger'
      return
    error: (response) ->
    	console.log("Something went wrong")

dismissForm = ->
	$("#call_back").on "hidden.bs.modal", ->
		$(@).find("input[type='text'],textarea,input[type='email'],input[type='tel']").val("")

$(document).on "ready page:change", ->
	dismissForm()

	$("#call_timings").datetimepicker
    format: 'hh:mm A'