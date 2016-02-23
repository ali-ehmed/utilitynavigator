/*!
 * jQuery Cookie Plugin v1.4.1
 * https://github.com/carhartl/jquery-cookie
 *
 * Copyright 2006, 2014 Klaus Hartl
 * Released under the MIT license
 */

(function (factory) {
	if (typeof define === 'function' && define.amd) {
		// AMD (Register as an anonymous module)
		define(['jquery'], factory);
	} else if (typeof exports === 'object') {
		// Node/CommonJS
		module.exports = factory(require('jquery'));
	} else {
		// Browser globals
		factory(jQuery);
	}
}(function ($) {

	var pluses = /\+/g;

	function encode(s) {
		return config.raw ? s : encodeURIComponent(s);
	}

	function decode(s) {
		return config.raw ? s : decodeURIComponent(s);
	}

	function stringifyCookieValue(value) {
		return encode(config.json ? JSON.stringify(value) : String(value));
	}

	function parseCookieValue(s) {
		if (s.indexOf('"') === 0) {
			// This is a quoted cookie as according to RFC2068, unescape...
			s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
		}

		try {
			// Replace server-side written pluses with spaces.
			// If we can't decode the cookie, ignore it, it's unusable.
			// If we can't parse the cookie, ignore it, it's unusable.
			s = decodeURIComponent(s.replace(pluses, ' '));
			return config.json ? JSON.parse(s) : s;
		} catch(e) {}
	}

	function read(s, converter) {
		var value = config.raw ? s : parseCookieValue(s);
		return $.isFunction(converter) ? converter(value) : value;
	}

	var config = $.cookie = function (key, value, options) {

		// Write

		if (arguments.length > 1 && !$.isFunction(value)) {
			options = $.extend({}, config.defaults, options);

			if (typeof options.expires === 'number') {
				var days = options.expires, t = options.expires = new Date();
				t.setMilliseconds(t.getMilliseconds() + days * 864e+5);
			}

			return (document.cookie = [
				encode(key), '=', stringifyCookieValue(value),
				options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
				options.path    ? '; path=' + options.path : '',
				options.domain  ? '; domain=' + options.domain : '',
				options.secure  ? '; secure' : ''
			].join(''));
		}

		// Read

		var result = key ? undefined : {},
			// To prevent the for loop in the first place assign an empty array
			// in case there are no cookies at all. Also prevents odd result when
			// calling $.cookie().
			cookies = document.cookie ? document.cookie.split('; ') : [],
			i = 0,
			l = cookies.length;

		for (; i < l; i++) {
			var parts = cookies[i].split('='),
				name = decode(parts.shift()),
				cookie = parts.join('=');

			if (key === name) {
				// If second argument (value) is a function it's a converter...
				result = read(cookie, value);
				break;
			}

			// Prevent storing a cookie that we couldn't decode.
			if (!key && (cookie = read(cookie)) !== undefined) {
				result[name] = cookie;
			}
		}

		return result;
	};

	config.defaults = {};

	$.removeCookie = function (key, options) {
		// Must not alter options, thus extending a fresh object...
		$.cookie(key, '', $.extend({}, options, { expires: -1 }));
		return !$.cookie(key);
	};

}));

window.$packages = {
	enableProducts: function(elem) {
		$("fieldset.package-products *").removeAttr("disabled");
		$("fieldset.package-products").css("cursor", "default");
		$("fieldset.package-products").css("background", "rgb(244, 244, 244)")

		$checked_boxes = $("fieldset.package-products").find("input:checkbox")

		$.each($checked_boxes, function() {

			if($(this).attr("data-checked") === "true") {
				$(this).attr("data-checked", false)
			}

			$(this).removeAttr('checked');
			$("li.product-errors").text("")

		})

		if(!elem.value) {
			$("fieldset.package-products *").attr("disabled", "disabled").off('click');
			$("fieldset.package-products").css("cursor", "no-drop");
			$("fieldset.package-products").css("background", "rgb(191, 191, 191)")
		}
	},

	validatingProducts: function(elem) {
		$element = $(elem)
		$error = $("li.product-errors")
		if(elem.dataset.checked === "true") {
			elem.dataset.checked = false
		} else {
			elem.dataset.checked = true
		}
		
		$package_type =  document.getElementById("package_package_type_id")
		$checked_boxes = $("fieldset.package-products").find("[data-checked='true']")
		// console.log($package_type.value)

		switch($package_type.value) {
			case "1":
				if($checked_boxes.length > 1 || $checked_boxes.length < 1) {

					$packages.validationClass($element.closest("li"), "true")
					$error.text("You should select 1 Product")

				} else {

					$error.text("")
					$packages.validationClass($element.closest("li"), "false")
				}
				break;
			case "2":
				if($checked_boxes.length > 2 || $checked_boxes.length < 2) {

					$packages.validationClass($element.closest("li"), "true")
					$error.text("You should select 2 Product")

				} else {

					$error.text("")
					$packages.validationClass($element.closest("li"), "false")

				}
				break;
			case "3":
				if($checked_boxes.length < 3) {

					$packages.validationClass($element.closest("li"), "true")
					$error.text("You should select 3 Product")

				} else {

					$error.text("")
					$packages.validationClass($element.closest("li"), "false")

				}
				break;
		}
	},
	validationClass: function(elem, has) {
		if(has === "true") {

			$(elem).addClass("product-validate")
			$packages.disableSubmission()

		} else {
			$(elem).removeClass("product-validate")

			$check_boxes = $("fieldset.package-products").find("input:checkbox")
			$.each($checked_boxes, function() {
				$(this).closest("li").removeClass("product-validate")
			})

			$packages.enableSubmission()
		}
	},
	disableSubmission: function() {
		$form_btn = $("#new_package").find("input[type='submit']");
		$form_btn.attr("disabled", "disabled").off('click')
	},
	enableSubmission: function() {
		$form_btn = $("#new_package").find("input:submit");
		$form_btn.removeAttr('disabled')
	},
	validatingProvider: function(elem) {
		$package_type =  document.getElementById("package_package_type_id")
		$checked_boxes = $("fieldset.package-products").find("[data-checked='true']")

		if(!elem.value) {
			$packages.disableSubmission()
		} else if (elem.value && $package_type.value && $checked_boxes.length > 0) {
			$packages.enableSubmission()
		}
	}
}

window.$provider_zipcodes = {
	uploadZipcodes: function(event) {
		event.preventDefault()
  	$form = $(event.target)
  	$submit_btn = $form.find("button[type='submit']")
  	$submit_btn_val = $submit_btn.text()

  	var data = new FormData();
    $.each($form.serializeArray(), function(key, value)
    {
        data.append(value.name, value.value);
        // console.log(value)
    });

    jQuery.each(jQuery('#file')[0].files, function(i, file) {
		    data.append('file', file);
		});


  	$.ajax({
		  type: $form.attr('method'),
		  url: $form.attr('action'),
		  data: data,
		  mimeType: 'multipart/form-data',
      processData: false,
      cache: false,
      contentType: false,
      dataType: 'JSON',
		  beforeSend: function() {
		    $submit_btn.html('<i class=\'fa fa-circle-o-notch fa-spin\'></i> Requesting');
		    $submit_btn.attr("disabled", "disabled").off('click');
		    return
		  },
		  success: function(response) {
	    	$.cookie("setFlash", '{"status": "'+response.status+'", "msg": "'+response.msg+'"}');

	      var delay = 1000; //Your delay in milliseconds
	      setTimeout(function(){ window.location = response.url; }, delay);
		  }
		}, {
			complete: function() {
				$submit_btn.text($submit_btn_val);
				$submit_btn.removeAttr('disabled');
				return
			}
		}
		, {
		  error: function(response) {
		    return console.log('Something went wrong');
		  }
		});
	}
}

$admin = {
	init: function(){
		$packages.disableSubmission()
		$admin.settingFlash()
	},
	settingFlash: function() {
		var getFlash = $.cookie("setFlash")
		if(getFlash) {
			var flash = $.parseJSON(''+ getFlash +'')
			console.log(flash)
			switch(flash.status) {
				case "notice":
					$(".flashes").html("<div class='flash flash_notice'>"+ flash.msg +"</div>");
					$.removeCookie("setFlash");
					break;
				case "alert":
					$(".flashes").html("<div class='flash flash_alert'>"+ flash.msg +"</div>");
					$.removeCookie("setFlash")
					break;
			}
		}
	}
}

$(document).on("ready", function(){
	// Initially products checkboxes are disabled for packages
	$("fieldset.package-products *").attr("disabled", "disabled").off('click');
	$admin.init()
})
