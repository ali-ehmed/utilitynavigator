currentAppActiveLink = (elem) ->
	elem.find("a[href=\"#{@location.pathname}\"]").parent().addClass "active-link"

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
 	
$(document).on 'page:change', ->
	currentAppActiveLink $('.navbar-links')
	offerSearchNotice()

	$('[data-toggle="popover"]').popover()