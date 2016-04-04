// Signing In User
signInUser = function() {
	$("#new_user").on("submit", function(e) {
		e.preventDefault();
		$this = $(this);
		$button = $this.find("button[type='submit']")
		$.ajax({
		  type: $this.attr("method"),
		  url: $this.attr("action"),
		  data: $this.serialize(),
		  beforeSend: function() {
		  	$button.prop("disabled", "disabled")
		    return $button.html('<i class=\'fa fa-spinner fa-spin\'></i> Signing In');
		  },
		  success: function(response) {
		    window.location = response.location
		    return true
		  },
		  error: function(response) {
		  	console.log(response)
		  	$button.html("Sign in");
		  	$button.removeAttr("disabled")
	  		return $.notify({
		      icon: 'glyphicon glyphicon-warning-sign',
		      title: '<strong>Instructions:</strong><br />',
		      message: response.responseText
		    }, {
		      type: 'danger'
		    });
		  }
		});
	})
}

$(document).ready(function () {
	// signInUser();
})