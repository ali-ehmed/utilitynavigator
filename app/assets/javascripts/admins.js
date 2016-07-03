/*
	author: -> Ali Ahmed (Software Engineer - Ruby On Rails)
									Admin Panel Javascript
*/

//= require jquery.cookie

// Setting valid form variable
window.validPackageForm = true;

// Packages object
window.$packages = {
	errorTemplate: function(message, elem) {
		elem = elem == undefined ? "" : elem;
		message = message == undefined ? "" : message;
		template = '<p class="display-error" style="color: red;"><strong>Error: </strong>'+ message +'</p>';

		if(!elem.next().hasClass("display-error")) {
			return template;
		}

		return null;
	},
	enableProducts: function(elem) {
		$("fieldset.package-products *").removeAttr("disabled");
		$("fieldset.package-products").css("cursor", "default");
		$("fieldset.package-products").css("background", "rgb(244, 244, 244)");

		$checked_boxes = $("fieldset.package-products").find("input:checkbox");

		$.each($checked_boxes, function() {

			if($(this).attr("data-checked") === "true") {
				$(this).attr("data-checked", false);
			}

			$(this).removeAttr('checked');
			$("li.product-errors").text("");
			$(this).closest("li").removeClass("product-validate");

		});

		if(!elem.value) {
			$("li.product-errors").text("Please Select Products");
			$("fieldset.package-products *").attr("disabled", "disabled").off('click');
			$("fieldset.package-products").css("cursor", "no-drop");
			$("fieldset.package-products").css("background", "rgb(191, 191, 191)");
		}
	},
	// Price info
	packageCharacterLengthValidation: function(elem, c_length) {
		$elem = $(elem);

		console.log($elem.val().length);

		if($elem.val().length > c_length) {
			$elem.after($packages.errorTemplate("Field not exceed "+ c_length +" characters", $elem));
			window.validPackageForm = false;
		} else {
			$elem.next().remove();
			window.validPackageForm = true;
		}
	},
	packagePriceValidation: function(elem) {
		$elem = $(elem);

		if(isNaN($elem.val()) === true) {
			console.log(isNaN($elem.val()));
			$elem.after($packages.errorTemplate("Price must be a demical value", $elem));
			window.validPackageForm = false;
		} else {
			$elem.next().remove();
			window.validPackageForm = true;
		}
	},
	addPriceField: function(elem) {
		$this = $(elem);

		if($this.val() === "Add Price") {
			$this.next().show();
			$this.next().val("");
			return;
		} else if ($this.val() === "Include") {
			$this.next().val("Included");
		} else {
			$this.next().val("");
		}

		console.log($this.next().val());

		$this.next().hide();
		return;
	},
	setRequiredFields: function(elem) {
		$this = $(elem);
		$sub_fields = $this.closest("li").next().find("input[type='text']");
		$sub_fields_header = $this.closest("li").next().find("select");

		if($this.val() === "Required" || $this.val() === "Include") {
			$this.closest("li").next().show();

			$.each($sub_fields, function() {
				if($(this).is(':visible')) {
					$(this).hide();
				}
				$(this).val("");
			});

			$.each($sub_fields_header, function() {
				$(this).val("");
			});

			return;
		} else {

			$.each($sub_fields, function() {
				$(this).val("");
			});

			$this.closest("li").next().hide();
		}

		return;
	},
	// Products Type and Products
	validatingProducts: function(elem) {
		$element = $(elem);
		$error = $("li.product-errors");

		if(elem.dataset.checked === "true") {
			elem.dataset.checked = false
		} else {
			elem.dataset.checked = true
		}

		$package_type =  document.getElementById("package_package_type_id");
		$checked_boxes = $("fieldset.package-products").find("[data-checked='true']");

		switch($package_type.value) {
			case "1":
				if($checked_boxes.length > 1 || $checked_boxes.length < 1) {

					$packages.validationClass($element.closest("li"), "true");
					$error.text("You should select 1 Product");

				} else {

					$error.text("");
					$packages.validationClass($element.closest("li"), "false");
				}
				break;
			case "2":
				if($checked_boxes.length > 2 || $checked_boxes.length < 2) {

					$packages.validationClass($element.closest("li"), "true");
					$error.text("You should select 2 Products");

				} else {

					$error.text("");
					$packages.validationClass($element.closest("li"), "false");

				}
				break;
			case "3":
				if($checked_boxes.length < 3) {

					$packages.validationClass($element.closest("li"), "true");
					$error.text("You should select 3 Products");

				} else {

					$error.text("");
					$packages.validationClass($element.closest("li"), "false");

				}
				break;
		}
	},

	// Validation Error Dsiplay
	validationClass: function(elem, has) {
		if(has === "true") {

			$(elem).addClass("product-validate");
			$packages.disableSubmission();

		} else {
			$(elem).removeClass("product-validate");

			$check_boxes = $("fieldset.package-products").find("input:checkbox");
			$.each($check_boxes, function() {
				$(this).closest("li").removeClass("product-validate");
			})

			$packages.enableSubmission();
		}
	},
	disableSubmission: function() {
		window.validPackageForm = false
	},
	enableSubmission: function() {
		window.validPackageForm = true
	},
	validatingProvider: function(elem) {
		$package_type =  document.getElementById("package_package_type_id");
		$checked_boxes = $("fieldset.package-products").find("[data-checked='true']");

		if(!elem.value) {
			$packages.disableSubmission();
		} else if (elem.value && $package_type.value && $checked_boxes.length > 0) {
			$packages.enableSubmission();
		}
	}
};

// Provider zipcode upload JS (Deprecated)

window.$provider_zipcodes = {
	uploadZipcodes: function(event) {
		event.preventDefault();
  	$form = $(event.target);
  	$submit_btn = $form.find("button[type='submit']");
  	$submit_btn_val = $submit_btn.text();

  	var data = new FormData();
    $.each($form.serializeArray(), function(key, value) {
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
		    return;
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
				return;
			}
		}, {
		  error: function(response) {
		    return console.log('Something went wrong');
		  }
		});
	}
}

// Initializing
$admin = {
	init: function(){
		// $packages.disableSubmission();
		$admin.settingFlash();
		$admin.submitPackageForm();
	},
	settingFlash: function() {
		var getFlash = $.cookie("setFlash");
		if(getFlash) {
			var flash = $.parseJSON(''+ getFlash +'');
			console.log(flash);

			switch(flash.status) {
				case "notice":
					$(".flashes").html("<div class='flash flash_notice'>"+ flash.msg +"</div>");
					$.removeCookie("setFlash", { path: ""+ window.location.pathname +"" });
					break;
				case "alert":
					$(".flashes").html("<div class='flash flash_alert'>"+ flash.msg +"</div>");
					$.removeCookie("setFlash", { path: ""+ window.location.pathname +""});
					break;
			}
		}
	},
	submitPackageForm: function() {
		$("form").on("submit", function() {
			if(window.validPackageForm === false) {
				return false;
			}
		})
	}
};

$(document).ready(function () {
	/* Initializing Functions */
	$admin.init();

	// Initially products checkboxes are disabled for packages
	if($("#package_package_type_id").val() == "") {
		// window.validPackageForm = false;
		$("fieldset.package-products").css("background-color", "rgb(191, 191, 191)");
  	$("fieldset.package-products").css("cursor", "no-drop");
		$("fieldset.package-products *").attr("disabled", "disabled").off('click');
	}

	// Tinymce Editor
	tinymce.init({
	  selector: '.package-editor',
	  height: 180,
	  plugins: [
	    'advlist autolink lists link image charmap print preview anchor',
	    'searchreplace visualblocks code fullscreen',
	    'insertdatetime media table contextmenu paste code'
	  ],
	  toolbar: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
		color_picker_callback: function(callback, value) {
	    callback('#FF00FF');
	  }
	});

	$("a#approval_statuses").closest("li").css("border-bottom", "solid 5px #ebebeb");
});

/* ******************** CUSTOM JS END ********************* */
