
/*
	Author: aliahmed (Software Engineer - Ruby on Rails)
	This coffee contains all the front end functionality of Utility Navigator
 */

(function() {
  var closeSearchNotice, geocodeLatitideAndLongtitude, loadChannels, navbarActiveLink, removeActiveIconProviders, scrollingReviewNote, validatePreferredTimings;

  $.fn.serializeObject = function() {
    var a, o;
    o = {};
    a = this.serializeArray();
    $.each(a, function() {
      if (o[this.name] !== void 0) {
        if (!o[this.name].push) {
          o[this.name] = [o[this.name]];
        }
        o[this.name].push(this.value || '');
      } else {
        o[this.name] = this.value || '';
      }
    });
    return o;
  };

  String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  };

  navbarActiveLink = function() {
    var $a;
    $a = $('.navbar-links').find('a[href="' + this.location.pathname + '"]');
    $a.parent().addClass('active-link');
    switch ($a.text()) {
      case 'TWC':
        $a.css('background-image', 'url("assets/arrow-twc.png")');
        break;
      case 'COX':
        $a.css('background-image', 'url("assets/arrow-cox.png")');
        break;
      case 'CHARTER':
        $a.css('background-image', 'url("assets/arrow-charter.png")');
    }
  };

  window.offerSearchNotice = function() {
    return $('body').animate({
      scrollTop: 0
    }, 'slow', function() {
      $('.pop-msg').popover("show");
      return $('.pop-msg').on('shown.bs.popover', function() {
        $(this).next().find(".popover-title").css("background-color", "#9932CC");
        $(this).next().find(".popover-content").css("color", "#232121");
        $(this).next().css("width", "100%");
      });
    });
  };

  closeSearchNotice = function() {
    return $(document).on('click', function(e) {
      return $(".search-form-popover-title").closest(".popover").popover("hide");
    });
  };

  scrollingReviewNote = function() {
    return (function($) {
      var element, footerY, originalY, topMarginFromBottom;
      element = $('.follow-equiptments');
      if (element.length) {
        originalY = element.offset().top;
        footerY = $(".application-footer").offset().top - 700;
        topMarginFromBottom = element.hasClass('on-payment') ? 155 : 120;
        element.css('position', 'relative');
        $(window).on('scroll', function(event) {
          var scrollTop, totalMargin;
          scrollTop = $(window).scrollTop();
          if (scrollTop < originalY) {
            totalMargin = 0;
          } else if (scrollTop > footerY) {
            totalMargin = scrollTop - topMarginFromBottom;
          } else {
            totalMargin = scrollTop - originalY + 80;
          }
          element.stop(false, false).animate({
            top: totalMargin
          }, 300);
        });
      }
    })(jQuery);
  };

  removeActiveIconProviders = function() {
    return (function($) {
      var element, icon;
      element = $('nav li.active-link').find("a");
      icon = element.attr("style");
      if (element.length) {
        $(window).on('scroll', function(event) {
          var $this;
          $this = $(this);
          if ($this.scrollTop() <= 75) {
            return element.attr("style", icon);
          } else {
            return element.removeAttr("style");
          }
        });
      }
    })(jQuery);
  };

  window.settingFilterActive = function(elem) {
    var $links;
    $links = $('.packages-category-name a');
    $.each($links, function() {
      return $(this).find("span.package-filter").css('background-image', 'url("assets/filter-circle.png")');
    });
    return $(elem).find("span.package-filter").css('background-image', 'url("assets/filter-circle-select.png")');
  };

  window.loadPackages = function(elem) {
    var $pagination;
    window.active_product = "";
    window.active_product = $(elem).data("product");
    $pagination = $(elem).parent().prev().find(".pagination");
    $.getScript($pagination.find("li.next a").attr("href"));
    $pagination.show();
    $pagination.html("<i class=\'fa fa-spinner fa-spin fa-3x\'></i>");
    return $(elem).prop("disabled", "disabled");
  };

  geocodeLatitideAndLongtitude = function(address) {
    if (address == null) {
      address = "6909 helena way, mckinney, tx 75070, usa";
    }
    return $.get('https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key=#{window.common.geocoder}', function(data) {
      return console.log(data.results[0].geometry.location);
    }).done(function() {
      console.log('Geocoding Done');
    }).fail(function() {
      console.log("no location found");
      return "no result found";
    });
  };

  validatePreferredTimings = function() {
    return $('form#new_payment').on('submit', function(e) {
      var checkout_date, checkout_timing, time_zone;
      checkout_timing = $(this).find('div.checkout_timing').find('select').val();
      checkout_date = $(this).find('div.checkout_date').find('input').val();
      time_zone = $(this).find('select#timings_time_zone').val();
      console.log(time_zone);
      if (checkout_timing === '' || checkout_date === '') {
        $.notify({
          icon: 'glyphicon glyphicon-warning-sign',
          title: '<strong>Instructions:</strong><br />',
          message: 'Select at least 1 Preferred Time & Date'
        }, {
          type: 'danger'
        });
        return false;
      }
      if (time_zone === '') {
        $.notify({
          icon: 'glyphicon glyphicon-warning-sign',
          title: '<strong>Instructions:</strong><br />',
          message: 'Select Time Zone'
        }, {
          type: 'danger'
        });
        return false;
      }
      return true;
    });
  };

  window.radioValidations = function(array) {
    var $val;
    $val = true;
    $.each(array, function() {
      if (!$(this).attr("checked")) {
        $val = false;
        return true;
      } else {
        $val = true;
        return false;
      }
    });
    return $val;
  };

  loadChannels = function() {
    $(document).on("click", "a.channel-comparison-link", function(e) {
      var $link;
      e.preventDefault();
      $link = $(this);
      $link.html('<i class=\'fa fa-spinner fa-spin\'></i> Loading Channels');
      return $.get('/load_channels', {
        provider: $link.data('provider')
      }, function(data) {}).done(function() {
        $link.html('CHANNEL COMPARISON');
        return false;
      }).fail(function() {
        $link.html('CHANNEL COMPARISON');
        console.log('Something went wrong');
        return false;
      });
    });
  };

  $(document).on("page:change", function() {

    /* Initializing */
    navbarActiveLink();
    closeSearchNotice();
    if (navigator.userAgent.toLowerCase().indexOf("mobile") === -1) {
      scrollingReviewNote();
    }
    removeActiveIconProviders();
    validatePreferredTimings();
    loadChannels();
    $('[data-toggle="popover"]').popover();
    $('[data-toggle="tooltip"]').tooltip();
    if ($(".has_packages").length) {
      $(".pagination").css("margin", "0px 0px");
      return $(".pagination").hide();
    }
  });

}).call(this);
