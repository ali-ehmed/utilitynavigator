# Validating Search Form
perform_validations = (address) ->
  $is_valid = true
  $input_address = address

  $.each $input_address, (key, value) ->
    if value == ''
      $.notify {
        icon: 'glyphicon glyphicon-warning-sign'
        title: '<strong>Instructions:</strong><br />'
        message: 'Please Enter ' + key.capitalize()
      }, type: 'danger'

      $is_valid = false
      return false

  return false if $is_valid == false

  console.log $input_address.address.substring(0, 1)

  if $.isNumeric($input_address.address.substring(0, 1)) == false
  	$.notify {
	    icon: 'glyphicon glyphicon-warning-sign'
	    title: '<strong>Instructions:</strong><br />'
	    message: 'Address should start from digits'
	  }, type: 'danger'

  	$is_valid = false
  	return $is_valid

  unless $input_address.zipcode.length == 5
  	$.notify {
	    icon: 'glyphicon glyphicon-warning-sign'
	    title: '<strong>Instructions:</strong><br />'
	    message: 'Zip Code should not be less than or greater than 5 digits'
	  }, type: 'danger'

  	$is_valid = false
  	return $is_valid


# Search Method
searchProviders = ->
  $('form#search-deals-offer-form').on 'submit', (e) ->

    e.preventDefault()
    $form = $(this)

    $full_address_json = JSON.stringify($form.serializeObject())
    $full_address_json = jQuery.parseJSON($full_address_json)
    delete $full_address_json['utf8']

    $input_address = $full_address_json
    delete $full_address_json['apt']
    delete $full_address_json['filters']

    console.log $input_address

    #Checking Validations of search inputs

    $is_valid = perform_validations($input_address)

    return false if $is_valid == false

    $full_address = []
    $.each $full_address_json, (key, value) ->
      $full_address.push value

    $full_address = $full_address.join(', ')

    # Fetching Latitude and Longtitude From Google Geocoding Api
    $.get('https://maps.googleapis.com/maps/api/geocode/json?address=' + $full_address + '&key=#{window.common.geocoder}', (data) ->

      if data.status == 'ZERO_RESULTS'
        $.notify {
          icon: 'glyphicon glyphicon-warning-sign'
          title: '<strong>Instructions:</strong><br />'
          message: 'No location found'
        }, type: 'danger'
        return false

      console.log data.results[0].geometry.location
      results = data.results[0].geometry.location
      results["address"] = $full_address

      if data.results[0].partial_match or data.results[0].geometry.bounds
      	results["partial_match"] = true

    	# Searching Providers with Ajax Call
      $.ajax {
		    type: "Get"
		    url: "/offers/broadband_providers"
		    data: results
		    dataType: "JSON"
		    beforeSend: ->
		    	$form.find("button[type='submit']").prop("disabled", "disabled")
		    	$form.find("button[type='submit']").html '<i class=\'fa fa-circle-o-notch fa-spin\'></i> We are looking up the packages'

		    	# Pausing slider
		    	# $('.carousel').carousel('pause')
		    success: (response) ->
		    	if response.status == "error"
		    		$.notify({
			        icon: 'glyphicon glyphicon-warning-sign'
			        title: '<strong>Instructions:</strong><br />'
			        message: response.msg
			      }, type: 'danger')
		    	else
			    	$form.unbind("submit")
			    	$form.submit()
			    	console.log("Request Sent")
	    	complete: ->
	    		$form.find("button[type='submit']").removeAttr("disabled")
	    		$form.find("button[type='submit']").html 'Find Deals &amp; Offers'
		    error: ->
		    	$.notify({
		        icon: 'glyphicon glyphicon-warning-sign'
		        title: '<strong>Instructions:</strong><br />'
		        message: 'Something went wrong. Please try again.'
		      }, type: 'danger')
			}
      return
    ).done(->
      console.log 'Geocoding Done'
      return
    ).fail ->
      console.log 'no location found'
      return

$(document).on "page:change", ->
  searchProviders()
