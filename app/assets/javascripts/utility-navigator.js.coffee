currentAppActiveLink = (elem) ->
	elem.find("a[href=\"#{@location.pathname}\"]").parent().addClass "active-link"

$(document).on 'page:change', ->
	currentAppActiveLink $('.navbar-links')