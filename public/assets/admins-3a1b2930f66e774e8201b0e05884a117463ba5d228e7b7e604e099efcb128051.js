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
	},
	init: function(){
		$packages.disableSubmission()
	}
}

$(document).on("ready", function(){
	// Initially products checkboxes are disabled for packages
	$("fieldset.package-products *").attr("disabled", "disabled").off('click');
	$packages.init()
})
