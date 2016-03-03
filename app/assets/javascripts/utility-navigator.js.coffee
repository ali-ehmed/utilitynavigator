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
 	
$(document).on 'page:change', ->
	navbarActiveLink()
	offerSearchNotice()
	scrollingReviewNote() if navigator.userAgent.toLowerCase().indexOf("mobile") == -1

	$('[data-toggle="popover"]').popover()