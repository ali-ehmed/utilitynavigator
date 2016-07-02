(function() {
  var checkedCompareBoxes, comparePakages, comparingPackages, validateExtraEquiptment;

  comparingPackages = function(package_ids, elem) {
    var html;
    console.log(package_ids);
    console.log(window.$compare_url);
    html = elem.html();
    return $.ajax({
      type: "Get",
      url: window.$compare_url.join(),
      data: {
        package_ids: package_ids
      },
      beforeSend: function() {
        return elem.html('<i class=\'fa fa-circle-o-notch fa-spin\'></i> Comparing');
      },
      success: function(response) {
        return elem.html(html);
      },
      error: function() {
        return $.notify({
          icon: 'glyphicon glyphicon-warning-sign',
          title: '<strong>Instructions:</strong><br />',
          message: 'Something went wrong'
        }, {
          type: 'danger'
        });
      }
    });
  };

  window.$compare_checkboxex = [];

  window.$compare_url = [];

  checkedCompareBoxes = function() {
    window.$compare_checkboxex = [];
    $.each($("#package-details").find("input:checked"), function(i) {
      var $this;
      $this = $(this);
      i += 1;
      window.$compare_checkboxex.push($this.data("package-id"));
      return window.$compare_checkboxex = window.$compare_checkboxex.filter(Number);
    });
    return console.log(window.$compare_checkboxex);
  };

  window.compareMe = function(elem) {
    checkedCompareBoxes();
    window.$compare_url = [];
    window.$compare_url.push($(elem).data("compare-url"));
    if (elem.value === "false") {
      return elem.value = "true";
    } else {
      return elem.value = "false";
    }
  };

  comparePakages = function() {
    var $this;
    $this = $(this);
    console.log(window.$compare_checkboxex.length);
    return $('#compare_packages').on('click', function() {
      if (window.$compare_checkboxex.length <= 1) {
        $.notify({
          icon: 'glyphicon glyphicon-warning-sign',
          title: '<strong>Instructions:</strong><br />',
          message: 'You must select at least <strong>2 Packages</strong> to compare'
        }, {
          type: 'danger'
        });
      } else if (window.$compare_checkboxex.length > 3) {
        $.notify({
          icon: 'glyphicon glyphicon-warning-sign',
          title: '<strong>Instructions:</strong><br />',
          message: 'You can only compare <strong>3 packages</strong> at a time'
        }, {
          type: 'danger'
        });
      } else {
        comparingPackages(window.$compare_checkboxex, $this);
      }
    });
  };
  window.resetSelectedItem = function(elem) {
    var $radios, $this, total_cost, x, _cost, _results;
    $this = $(elem);
    total_cost = parseFloat(document.getElementById("total_cost").value);
    $radios = $this.closest("h4").next().find("li input");
    x = 0;
    _results = [];
    while (x < $radios.length) {
      if ($radios[x].dataset.installation === "true") {
        _cost = parseFloat(document.getElementById("installation_cost").value);
      } else {
        _cost = parseFloat(document.getElementById("equiptment_cost").value);
      }
      if ($($radios[x]).attr("checked")) {
        $radios[x].checked = false;
        _cost -= parseFloat(String($($radios[x]).data("price")).replace("$", ""));
        total_cost -= parseFloat(String($($radios[x]).data("price")).replace("$", ""));
        if ($radios[x].dataset.installation === "true") {
          document.getElementById("installation_cost").value = _cost.toFixed(2);
        } else {
          document.getElementById("equiptment_cost").value = _cost.toFixed(2);
        }
        document.getElementById("total_cost").value = total_cost.toFixed(2);
        $($radios[x]).val("false");
        $($radios[x]).removeAttr("checked");
        if ($radios[x].dataset.installation === "true") {
          $(".installation_cost_span").text(_cost.toFixed(2));
        } else {
          $(".equiptment_cost_span").text(_cost.toFixed(2));
        }
        $(".total_cost_span").text("$" + total_cost.toFixed(2));
      }
      _results.push(x++);
    }
    return _results;
  };

  validateExtraEquiptment = function() {
    return $('form#extra_equiptments_form').on('submit', function(e) {
      var $errors, $provider, $valid, current_telephone_number, directory_listing, first_tv, fourth_outlet, fourth_tv, installation, internet_equiptment, modem, phone, service_agreement, wifi_installation, wifi_service;
      $valid = true;
      $provider = $('#package_provider').data("provider");
      $errors = [];
      first_tv = $("input[name='first_tv']");
      fourth_tv = $("input[name='fourth_tv']");
      fourth_outlet = $("input[name='4th_tv_outlet']");
      phone = $("input[name='phone']");
      modem = $("input[name='modem']");
      wifi_service = $("input[name='wifi']");
      internet_equiptment = $("input[name='internet_equiptment']");
      directory_listing = $("input[name='directory_listing']");
      current_telephone_number = $("input[name='current_telephone_number']");
      service_agreement = $("input[name='service_agreement']");
      installation = $("input[name='installation']");
      wifi_installation = $("input[name='wifi_installation']");

      if (first_tv.length >= 3) {
        if (radioValidations(first_tv) === false) {
          $errors.push("Please configure 1st TV");
          $valid = false;
        }
      }
      if (installation.length > 0) {
        if (radioValidations(installation) === false) {
          $errors.push("Please select Installation");
          $valid = false;
        }
      }
      if ($provider === "twc") {
        if (fourth_tv.length > 0) {
          if (radioValidations(fourth_tv) === true && !fourth_outlet.attr("checked")) {
            $errors.push("Please select 4th Outlet Avtivation fees");
            $valid = false;
          }
        }
      }
      if ($provider === "twc" || $provider === "charter") {
        if (modem.length > 0) {
          if (radioValidations(modem) === false) {
            $errors.push("Please select modem");
            $valid = false;
          }
        }
        if (wifi_service.length > 0 && modem.length > 0 && radioValidations(modem) === true) {
          if (radioValidations(wifi_service) === false) {
            $errors.push("Please also select wifi.");
            $valid = false;
          }
        }
        if (phone.length > 0) {
          if (radioValidations(phone) === false) {
            $errors.push("Choose one of the phone service");
            $valid = false;
          }
        }
      }
      if ($provider === "charter") {
        if (wifi_installation.length > 0 && radioValidations(wifi_service) === true) {
          if (radioValidations(wifi_installation) === false) {
            $errors.push("Please also select wifi installation.");
            $valid = false;
          }
        }
      }
      if ($provider === "cox") {
        if (internet_equiptment.length > 0 && radioValidations(internet_equiptment) === false) {
          $errors.push("Please select internet equiptment");
        }
        $valid = false;
        if (directory_listing.length > 0 && radioValidations(directory_listing) === false) {
          $errors.push("Please select directory listing");
        }
        $valid = false;
        if (current_telephone_number.length > 0 && radioValidations(current_telephone_number) === false) {
          $errors.push("Please select telephone number porting");
        }
        $valid = false;
        if (service_agreement.length > 0 && radioValidations(service_agreement) === false) {
          $errors.push("Please select service agreement");
          $valid = false;
        }
      }
      if ($errors.length === 0) {
        $valid = true;
      }
      if ($valid === false) {
        console.log($errors);
        $.notify({
          icon: 'glyphicon glyphicon-warning-sign',
          title: '<strong>Instructions:</strong><br />',
          message: $.map($errors, function(n) {
            return "<li>" + n + "</li>";
          }).join("")
        }, {
          type: 'danger'
        });
        return false;
      }
      return true;
    });
  };

  window.calculateEquiptmentCosts = function(elem) {
    var $radios, $this, total_cost, _cost;
    if (elem.dataset.installation === "true") {
      _cost = parseFloat(document.getElementById("installation_cost").value);
    } else {
      _cost = parseFloat(document.getElementById("equiptment_cost").value);
    }
    total_cost = parseFloat(document.getElementById("total_cost").value);
    $this = $(elem);
    if ($this.attr("type") === "radio") {
      $radios = $this.closest("ul").find("input[type='radio']");
      $.each($radios, function() {
        var $elem;
        $elem = $(this);
        if ($elem.val() === "true") {
          _cost -= parseFloat(String($elem.data("price")).replace("$", ""));
          total_cost -= parseFloat(String($elem.data("price")).replace("$", ""));
          if (elem.dataset.installation === "true") {
            document.getElementById("installation_cost").value = _cost;
          } else {
            document.getElementById("equiptment_cost").value = _cost;
          }
          document.getElementById("total_cost").value = total_cost;
          $elem.val("false");
          return $elem.removeAttr("checked");
        }
      });
    }
    $this.attr("checked", true);
    console.log($this.val());
    if (!(elem.value === "" || elem.value === "0")) {
      if (elem.value === "false") {
        elem.value = "true";
        if ($.isNumeric(elem.dataset.price.replace("$", ""))) {
          _cost += parseFloat(String(elem.dataset.price).replace("$", ""));
          total_cost += parseFloat(String(elem.dataset.price).replace("$", ""));
          _cost = _cost.toFixed(2);
          total_cost = total_cost.toFixed(2);
        }
      } else {
        elem.value = "false";
        $(elem).removeAttr("checked");
        if ($.isNumeric(elem.dataset.price.replace("$", ""))) {
          _cost -= parseFloat(String(elem.dataset.price).replace("$", ""));
          total_cost -= parseFloat(String(elem.dataset.price).replace("$", ""));
          _cost = _cost.toFixed(2);
          total_cost = total_cost.toFixed(2);
        }
      }
      if (elem.dataset.installation === "true") {
        document.getElementById("installation_cost").value = _cost;
      } else {
        document.getElementById("equiptment_cost").value = _cost;
      }
      document.getElementById("total_cost").value = total_cost;
    }
    if (elem.dataset.installation === "true") {
      $(".installation_cost_span").text(_cost);
    } else {
      $(".equiptment_cost_span").text(_cost);
    }
    return $(".total_cost_span").text("$" + total_cost);
  };

  $(document).ready(function() {
    validateExtraEquiptment();
    comparePakages();
  });

}).call(this);
