// Froala Html Editor Libraries

//= require jquery.cookie
//= require froala_editor.min.js
//= require plugins/align.min.js
//= require plugins/char_counter.min.js
//= require plugins/code_beautifier.min.js
//= require plugins/entities.min.js
//= require plugins/font_family.min.js
//= require plugins/font_size.min.js
//= require plugins/fullscreen.min.js
//= require plugins/image.min.js
//= require plugins/image_manager.min.js
//= require plugins/inline_style.min.js
//= require plugins/line_breaker.min.js
//= require plugins/link.min.js
//= require plugins/lists.min.js
//= require plugins/paragraph_format.min.js
//= require plugins/paragraph_style.min.js
//= require plugins/quick_insert.min.js
//= require plugins/quote.min.js
//= require plugins/save.min.js
//= require plugins/table.min.js
//= require plugins/url.min.js

// author: -> Ali Ahmed (Software Engineer - Ruby On Rails)
// Admin Panel Javascript 

// Setting valid form variable
window.validPackageForm = true

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
	// Price info
	packagePriceInfoValidation: function() {
		$("#package_price_info").on("blur", function(){
			console.log($(this).val().length)

			if($(this).val().length > 72) {
				$(".price-info-error").show()
				window.validPackageForm = false;
			} else {
				$(".price-info-error").hide()
				window.validPackageForm = true;
			}
		})
	},
	// Products Type and Products 
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
	
	// Validation Error Dsiplay
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

// Provider zipcode upload JS
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
		    $submit_btn.html('<i class=\'fa fa-circle-o-notch fa-spin\'></i> Uploading');
		    $submit_btn.attr("disabled", "disabled").off('click');
		    return
		  },
		  success: function(response) {
	    	$.cookie("setFlash", '{"status": "'+response.status+'", "msg": "'+response.msg+'"}', { path: response.url });

	      var delay = 1000; //Your delay in milliseconds
	      setTimeout(function(){ window.location = response.url; }, delay);
		  }
		}, {
			complete: function() {
				$submit_btn.text("Submit");
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

// Initializing
$admin = {
	init: function(){
		$packages.disableSubmission()
		$packages.packagePriceInfoValidation()
		$admin.settingFlash()
		$admin.submitNewPackageForm()
	},
	settingFlash: function() {
		var getFlash = $.cookie("setFlash")
		if(getFlash) {
			var flash = $.parseJSON(''+ getFlash +'')
			console.log(flash)
			switch(flash.status) {
				case "notice":
					$(".flashes").html("<div class='flash flash_notice'>"+ flash.msg +"</div>");
					$.removeCookie("setFlash", { path: ""+ window.location.pathname +"" });
					break;
				case "alert":
					$(".flashes").html("<div class='flash flash_alert'>"+ flash.msg +"</div>");
					$.removeCookie("setFlash", { path: ""+ window.location.pathname +""})
					break;
			}
		}
	},
	submitNewPackageForm: function() {
		$("#new_package").on("submit", function(){
			if(window.validPackageForm === false) {
				return false;
			}
		})
	}
}

$(document).on("ready", function(){
	// Initially products checkboxes are disabled for packages

	$("fieldset.package-products *").attr("disabled", "disabled").off('click');
	$admin.init()

	$('.package-content').froalaEditor()
	$('.package-promotions').froalaEditor()

	$("a#approval_statuses").closest("li").css("border-bottom", "solid 5px #ebebeb")
})