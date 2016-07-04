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
  $a = $('.navbar-links').find('a[href="' + @location.pathname + '"]')
  $a.parent().addClass 'active-link'

  switch $a.text()
    when 'TWC'
      $a.css 'background-image', 'url("assets/arrow-twc.png")'
    when 'COX'
      $a.css 'background-image', 'url("assets/arrow-cox.png")'
    when 'CHARTER'
      $a.css 'background-image', 'url("assets/arrow-charter.png")'
  return

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
      # Getting top of note to make the distance b/w note & header
      originalY = element.offset().top
      # Getting Top of footer to make the distance b/w note & footer
      footerY = $(".application-footer").offset().top - 700
      topMarginFromBottom = if element.hasClass('on-payment') then 155 else 120
      element.css 'position', 'relative'

      $(window).on 'scroll', (event) ->
        scrollTop = $(window).scrollTop()
        # console.log scrollTop
        # console.log footerY

        if scrollTop < originalY
          totalMargin = 0 # setting top margin
        else if scrollTop > footerY
          totalMargin = scrollTop - topMarginFromBottom # setting bottom margin
        else
          totalMargin = scrollTop - originalY + 80

        element.stop(false, false).animate {
          top: totalMargin
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

# For custom pagination in filters
window.loadPackages = (elem) ->
	window.active_product = ""
	window.active_product = $(elem).data("product")

	$pagination = $(elem).parent().prev().find(".pagination")

	$.getScript($pagination.find("li.next a").attr("href"))

	$pagination.show()
	$pagination.html("<i class=\'fa fa-spinner fa-spin fa-3x\'></i>")

	$(elem).prop("disabled", "disabled")

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

# Validating Preferred Timings On Reserving Order
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

window.radioValidations = (array) ->
	$val = true
	$.each array, ->
		if !$(this).attr("checked")
      $val = false
      return true
    else
    	$val = true
    	return false

	return $val

# Loading Channels
loadChannels = ->
  $(document).on "click", "a.channel-comparison-link", (e) ->
    e.preventDefault()
    $link = $(this)
    $link.html '<i class=\'fa fa-spinner fa-spin\'></i> Loading Channels'
    $.get('/load_channels', { provider: $link.data('provider') }, (data) ->
    ).done(->
      $link.html 'CHANNEL COMPARISON'
      false
    ).fail ->
      $link.html 'CHANNEL COMPARISON'
      console.log 'Something went wrong'
      false
  return

$(document).on "page:change", ->
  ### Initializing ###
  navbarActiveLink()
  closeSearchNotice()
  scrollingReviewNote() if navigator.userAgent.toLowerCase().indexOf("mobile") == -1
  removeActiveIconProviders()
  #geocodeLatitideAndLongtitude()
  validatePreferredTimings()
  loadChannels()
  
  $('[data-toggle="popover"]').popover()
  $('[data-toggle="tooltip"]').tooltip()

  #
  #
	# # For Search Filters
	# # This is custom pagination, as it needs to be hidden
	# # and See More btn should appear instead
  if $(".has_packages").length
    $(".pagination").css("margin", "0px 0px")
    $(".pagination").hide()
