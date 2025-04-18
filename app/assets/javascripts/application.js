// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require bootstrap-notify
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require jquery.cookie
//= require common/constant
//= require jasny-bootstrap.min

//= require_tree .

$(document).on("page:change", function() {
	// Notify
	$.notifyDefaults({
		allow_dismiss: true,
		z_index: 10000,
		offset: {
			y: 50,
			x: 33
		},
		placement: {
			from: "top",
			align: "right"
		}
	});
});
