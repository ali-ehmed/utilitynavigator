###
	Author: aliahmed (Software Engineer - Ruby on Rails)
	This coffee contains all the front end functionality of Utility Navigator
###

# Stringfy JSON
$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()
  $.each a, ->
    if o[@name] != undefined
      if !o[@name].push
        o[@name] = [ o[@name] ]
      o[@name].push @value or ''
    else
      o[@name] = @value or ''
    return
  o

# Custom function for string class
String::capitalize = ->
  @charAt(0).toUpperCase() + @slice(1)

navbarActiveLink = ->
	$a = $('.navbar-links').find("a[href=\"#{@location.pathname}\"]")
	$a.parent().addClass "active-link"

	switch $a.text() 
		when "TWC"
			$a.css('background-image', 'url("assets/arrow-twc.png")')
			break
		when "COX"
			$a.css('background-image', 'url("assets/arrow-cox.png")')
			break
		when "CHARTER"
			$a.css('background-image', 'url("assets/arrow-charter.png")')
			break

window.offerSearchNotice = () ->
	$('body').animate { scrollTop: 0 }, 'slow', ->
		$('.pop-msg').popover("show")
		$('.pop-msg').on 'shown.bs.popover', ->
		  $(@).next().find(".popover-title").css("background-color", "#9932CC")
		  $(@).next().find(".popover-content").css("color", "#232121")
		  $(@).next().css("width", "100%")
		  return

closeSearchNotice = () ->
	$(document).on 'click', (e) ->
		$(".search-form-popover-title").closest(".popover").popover("hide")

scrollingReviewNote = ->
	(($) ->
	  element = $('.follow-equiptments')
	  if element.length
		  originalY = element.offset().top
		  # Space between element and top of screen (when scrolling)
		  topMargin = if element.hasClass("on-payment") then 60 else 80
		  # Should probably be set in CSS; but here just for emphasi s
		  element.css 'position', 'relative'
		  $(window).on 'scroll', (event) ->
		    scrollTop = $(window).scrollTop()
		    # if ($(window).scrollTop() + $(window).height()) > ($(document).height() - 100)
		    # 	console.log scrollTop
		    element.stop(false, false).animate { 
		    	top: if scrollTop < originalY then 0 else scrollTop - originalY + 60
	    	}, 300
		    return
		  return
	) jQuery

removeActiveIconProviders = ->
	(($) ->
	  element = $('nav li.active-link').find("a")
	  icon = element.attr("style")
	  if element.length
		  $(window).on 'scroll', (event) ->
		  	$this = $(this)
		  	if $this.scrollTop() <= 75
		  		# console.log icon
		  		element.attr("style", icon)
		  	else
		  		# console.log $this.scrollTop()
		  		element.removeAttr("style")
		  return
	) jQuery

window.settingFilterActive = (elem) ->
  $links = $('.packages-category-name a')
  $.each $links, ->
  	$(this).find("span.package-filter").css('background-image', 'url("assets/filter-circle.png")')

  $(elem).find("span.package-filter").css('background-image', 'url("assets/filter-circle-select.png")')

window.resetSelectedItem = (elem) ->
	$this = $(elem)
	equiptment_cost = parseFloat(document.getElementById("equiptment_cost").value)
	total_cost = parseFloat(document.getElementById("total_cost").value)
	$radios = $this.closest("h4").next().find("li input")

	x = 0
	while x < $radios.length
    if $($radios[x]).attr("checked")
      $radios[x].checked = false

      equiptment_cost -= parseFloat($($radios[x]).data("price"))
      total_cost -= parseFloat($($radios[x]).data("price"))
      
      document.getElementById("equiptment_cost").value = equiptment_cost.toFixed(2)
      document.getElementById("total_cost").value = total_cost.toFixed(2)

      $($radios[x]).val("false")
      $($radios[x]).removeAttr("checked")

      $(".equiptment_cost_span").text(equiptment_cost.toFixed(2))
      $(".total_cost_span").text("$" + total_cost.toFixed(2))
      
      # return
    x++
    
# This method is calculating the extra equiptment cost
window.calculateEquiptmentCosts = (elem) ->
	equiptment_cost = parseFloat(document.getElementById("equiptment_cost").value)
	total_cost = parseFloat(document.getElementById("total_cost").value)
	
	$this = $(elem)

	if $this.attr("type") == "radio"
		# uncheckOtherSingletonSelect($this, total_cost, equiptment_cost)
		$radios = $this.closest("ul").find("input[type='radio']")
		$.each $radios, ->
			$elem = $(this)
			if $elem.val() == "true"
				
				equiptment_cost -= parseFloat($elem.data("price"))
				total_cost -= parseFloat($elem.data("price"))
				
				document.getElementById("equiptment_cost").value = equiptment_cost
				document.getElementById("total_cost").value = total_cost
				$elem.val("false")
				$elem.removeAttr("checked")

	$this.attr("checked", true)
	console.log($this.val())
	unless elem.value == "" or elem.value == "0"
		
		if elem.value == "false" 		
			elem.value = "true"
			if $.isNumeric(elem.dataset.price)
				equiptment_cost += parseFloat(elem.dataset.price)
				total_cost += parseFloat(elem.dataset.price)

				equiptment_cost = equiptment_cost.toFixed(2)
				total_cost = total_cost.toFixed(2)
		else
			elem.value = "false"
			$(elem).removeAttr("checked")
			if $.isNumeric(elem.dataset.price)
				equiptment_cost -= parseFloat(elem.dataset.price)
				total_cost -= parseFloat(elem.dataset.price)

				equiptment_cost = equiptment_cost.toFixed(2)
				total_cost = total_cost.toFixed(2)

		document.getElementById("equiptment_cost").value = equiptment_cost
		document.getElementById("total_cost").value = total_cost

	$(".equiptment_cost_span").text(equiptment_cost)
	$(".total_cost_span").text("$" + total_cost)

# For custom pagination in filters
window.loadPackages = (elem) ->
	window.active_product = ""
	window.active_product = $(elem).data("product")

	$pagination = $(elem).parent().prev().find(".pagination")

	$.getScript($pagination.find("li.next a").attr("href"))

	$pagination.show()
	$pagination.html("<i class=\'fa fa-spinner fa-spin fa-3x\'></i>")

	$(elem).prop("disabled", "disabled")

# This method is comparing the results on show page
comparingPackages = (package_ids, elem) ->
	console.log package_ids
	console.log window.$compare_url
	html = elem.html()
	$.ajax {
    type: "Get"
    url: window.$compare_url.join()
    data: package_ids: package_ids
    beforeSend: ->
      elem.html '<i class=\'fa fa-circle-o-notch fa-spin\'></i> Comparing'
    success: (response) ->
      elem.html(html)
    error: ->
    	$.notify({
        icon: 'glyphicon glyphicon-warning-sign'
        title: '<strong>Instructions:</strong><br />'
        message: 'Something went wrong'
      }, type: 'danger')
	}

window.$compare_checkboxex = []
window.$compare_url = []

checkedCompareBoxes = () ->
	window.$compare_checkboxex = []
	$.each $("#package-details").find("input:checked"), (i) ->
		$this = $(this)
		i += 1
		window.$compare_checkboxex.push($this.data("package-id"))
	
	console.log window.$compare_checkboxex

window.compareMe = (elem) ->
	checkedCompareBoxes()
	window.$compare_url = []
	window.$compare_url.push $(elem).data("compare-url")

	if elem.value == "false"
		elem.value = "true"
	else
		elem.value = "false"

comparePakages = ->
  $this = $(this)
  console.log window.$compare_checkboxex.length
  $('#compare_packages').on 'click', ->
    if window.$compare_checkboxex.length <= 1
      $.notify {
        icon: 'glyphicon glyphicon-warning-sign'
        title: '<strong>Instructions:</strong><br />'
        message: 'You must select at least <strong>2 Packages</strong> to compare'
      }, type: 'danger'
    else if window.$compare_checkboxex.length > 3
      $.notify {
        icon: 'glyphicon glyphicon-warning-sign'
        title: '<strong>Instructions:</strong><br />'
        message: 'You can only compare <strong>3 packages</strong> at a time'
      }, type: 'danger'
    else
      comparingPackages window.$compare_checkboxex, $this
    return

geocodeLatitideAndLongtitude = (address = "6909 helena way, mckinney, tx 75070, usa") ->
  $.get('https://maps.googleapis.com/maps/api/geocode/json?address=' +address+ '&key=#{window.common.geocoder}', (data) ->
  	console.log data.results[0].geometry.location
	).done(->
	  console.log 'Geocoding Done'
	  return
	).fail(->
	  console.log "no location found"
	  return "no result found"
	)

# Validating Preferred Timings On Payment
validatePreferredTimings = ->
  $('form#new_payment').on 'submit', (e) ->
    checkout_timing = $(this).find('div.checkout_timing').find('select').val()
    checkout_date = $(this).find('div.checkout_date').find('input').val()
    time_zone = $(this).find('select#timings_time_zone').val()

    console.log time_zone

    if checkout_timing == '' or checkout_date == ''
      $.notify {
        icon: 'glyphicon glyphicon-warning-sign'
        title: '<strong>Instructions:</strong><br />'
        message: 'Select at least 1 Preferred Time & Date'
      }, type: 'danger'
      return false
    if time_zone == ''
      $.notify {
        icon: 'glyphicon glyphicon-warning-sign'
        title: '<strong>Instructions:</strong><br />'
        message: 'Select Time Zone'
      }, type: 'danger'
      return false
    true

# Validatings On Extra Equipment
validateExtraEquiptment = ->
  $('form#extra_equiptments_form').on 'submit', (e) ->
    $valid = true
    $provider = $('#package_provider').data("provider")
    $errors = []
    
    first_tv = $("input[name='first_tv']:checked")
    first_tv_radio_btns = $("input[name='first_tv']")

    fourth_tv = $("input[name='fourth_tv']:checked")
    fourth_outlet = $("input[name='4th_tv_outlet']:checked")

    phone = $("input[name='phone']:checked")
    phone_radio_btns = $("input[name='phone']")
    modem = $("input[name='modem']:checked")

    internet_equiptment = $("input[name='internet_equiptment']:checked")
    directory_listing = $("input[name='directory_listing']:checked")
    current_telephone_number = $("input[name='current_telephone_number']:checked")
    service_agreement = $("input[name='service_agreement']:checked")

    installation = $("input[name='installation']:checked")

    if first_tv.length == 0 and first_tv_radio_btns.length >= 3
      $errors.push("Please configure 1st TV")
      $valid = false

    if installation.length == 0
      $errors.push("Please select Installation")
      $valid = false

    if $provider == "twc"
	    if fourth_tv.length > 0 and fourth_outlet.length == 0
        $errors.push("Please select 4th Outlet Avtivation fees")
	      $valid = false

    if $provider == "twc" or $provider == "charter"
	    if modem.length == 0
        $errors.push("Please select modem")
	      $valid = false

      if phone.length == 0 and phone_radio_btns.length > 1
        $errors.push("Choose one of the phone service")
	      $valid = false

    if $provider == "cox"
    	if internet_equiptment.length == 0
        $errors.push("Please select internet equiptment")
	      $valid = false

      if directory_listing.length == 0
        $errors.push("Please select directory listing")
	      $valid = false

    	if current_telephone_number.length == 0
        $errors.push("Please select telephone number porting")
	      $valid = false

      if service_agreement.length == 0
        $errors.push("Please select service agreement")
	      $valid = false

    if $errors.length == 0
    	$valid = true

    if $valid == false
    	console.log $errors
    	$.notify {
        icon: 'glyphicon glyphicon-warning-sign'
        title: '<strong>Instructions:</strong><br />'
        message: $.map($errors, (n) -> "<li>#{n}</li>").join("")
      }, type: 'danger'
    	return false 
    true

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

# Loading Channels
loadChannels = ->
	$('a.channel-comparison-link').on 'click', (e) ->
		e.preventDefault()
		$link = $(this)
		$link.html("<i class=\'fa fa-spinner fa-spin\'></i> Loading Channels")
		$.get('/load_channels', (data) ->
			# console.log data
		).done(->
			$link.html("CHANNEL COMPARISON")
			return false
		).fail(->
			$link.html("CHANNEL COMPARISON")
			console.log "Something went wrong"
			return false
		)

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
		    	$('.carousel').carousel('pause')
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
		        message: 'Something went wrong'
		      }, type: 'danger')
			}
      return
    ).done(->
      console.log 'Geocoding Done'
      return
    ).fail ->
      console.log 'no location found'
      return

$(document).ready ->
	### Initializing ###

	navbarActiveLink()
	closeSearchNotice()
	scrollingReviewNote() if navigator.userAgent.toLowerCase().indexOf("mobile") == -1
	comparePakages()
	removeActiveIconProviders()
	#geocodeLatitideAndLongtitude()
	searchProviders()
	validatePreferredTimings()
	loadChannels()
	validateExtraEquiptment()

	$('[data-toggle="popover"]').popover()
	$('[data-toggle="tooltip"]').tooltip()


	# For Search Filters
	# This is custom pagination, as it needs to be hidden 
	# and See More btn should appear instead
	if $(".packages-category-name").length
		$(".pagination").css("margin", "0px 0px")
		$(".pagination").hide()