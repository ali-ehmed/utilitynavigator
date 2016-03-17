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

offerSearchNotice = ->
	$('.offer-btn').on 'click', (e) ->
		e.preventDefault()
		$('html, body').animate { scrollTop: 0 }, 'slow', ->
			$('#search-deals-offer-form').popover("show")
			$('#search-deals-offer-form').on 'shown.bs.popover', ->
			  $(@).next().find(".popover-title").css("background-color", "#9932CC")
			  $(@).next().css("width", "100%")
			  return

 $(document).on 'click', (e) ->
 	$(".search-form-popover-title").closest(".popover").popover("hide")

scrollingReviewNote = ->
	(($) ->
	  element = $('.follow-equiptments')
	  if element.length
		  originalY = element.offset().top
		  # Space between element and top of screen (when scrolling)
		  topMargin = 80
		  # Should probably be set in CSS; but here just for emphasis
		  element.css 'position', 'relative'
		  $(window).on 'scroll', (event) ->
		    scrollTop = $(window).scrollTop()
		    element.stop(false, false).animate { top: if scrollTop < originalY then 0 else scrollTop - originalY + topMargin }, 300
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

	console.log(equiptment_cost)
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
			if $.isNumeric(elem.dataset.price)
				equiptment_cost -= parseFloat(elem.dataset.price)
				total_cost -= parseFloat(elem.dataset.price)

				equiptment_cost = equiptment_cost.toFixed(2)
				total_cost = total_cost.toFixed(2)

		document.getElementById("equiptment_cost").value = equiptment_cost
		document.getElementById("total_cost").value = total_cost

	$(".equiptment_cost_span").text(equiptment_cost)
	$(".total_cost_span").text("$" + total_cost)


window.loadPackages = (elem) ->
	window.active_product = ""
	window.active_product = $(elem).data("product")

	$pagination = $(elem).parent().prev().find(".pagination")

	$.getScript($pagination.find("li.next a").attr("href"))

	$pagination.show()
	$pagination.html("<i class=\'fa fa-circle-o-notch fa-spin fa-3x\'></i>")

	$(elem).prop("disabled", "disabled")

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

geocodeLatitideAndLongtitude = (address = "1600 Amphitheatre Parkway, Mountain View, CA") ->
  $.get('https://maps.googleapis.com/maps/api/geocode/json?address=' +address+ '&key=#{window.common.geocoder}', (data) ->
  	console.log data.results[0].geometry.location
	).done(->
	  console.log 'Geocoding Done'
	  return
	).fail(->
	  console.log "no location found"
	  return "no result found"
	)

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

    $is_valid = true

    $.each $input_address, (key, value) ->
      if value == ''
        $.notify {
          icon: 'glyphicon glyphicon-warning-sign'
          title: '<strong>Instructions:</strong><br />'
          message: 'Please enter ' + key.capitalize()
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
    	return false

    unless $input_address.zipcode.length == 5
    	$.notify {
		    icon: 'glyphicon glyphicon-warning-sign'
		    title: '<strong>Instructions:</strong><br />'
		    message: 'Zip Code should not be less than or greater than 5 digits'
		  }, type: 'danger'
    	return false

    $full_address = []
    $.each $full_address_json, (key, value) ->
      $full_address.push value

    $full_address = $full_address.join(', ')

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

      $.ajax {
		    type: "Get"
		    url: "/offers/broadband_providers"
		    data: results
		    dataType: "JSON"
		    beforeSend: ->
		    	$form.find("button[type='submit']").prop("disabled", "disabled")
		    	$form.find("button[type='submit']").html '<i class=\'fa fa-circle-o-notch fa-spin\'></i> We are looking up the packages'
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

$(document).on 'ready page:change', ->
	navbarActiveLink()
	offerSearchNotice()
	scrollingReviewNote() if navigator.userAgent.toLowerCase().indexOf("mobile") == -1
	comparePakages()
	removeActiveIconProviders()
	geocodeLatitideAndLongtitude()
	searchProviders()

	$('[data-toggle="popover"]').popover()
	$('[data-toggle="tooltip"]').tooltip()

	if $(".packages-category-name").length
		$(".pagination").css("margin", "0px 0px")
		$(".pagination").hide()