module PackagesHelper
  def get_package_type filters
    case filters.length
    when 1
      return Package::SINGLE_PLAY
    when 2
      return Package::DOUBLE_PLAY
    else
      return Package::TRIPLE_PLAY
    end
  end

  # this helper is very imp, as it has all the cable tvs
  # which are added from admin panel on the basis of Providers
  # if there is to add a new field in tv section the add the newly field
  # name in this array
  def provider_televisions(count_num)
		[
			"dvr_box_#{count_num}",
			"additional_hd_#{count_num}",
			"dta_#{count_num}",
			"4th_tv_install_#{count_num}",
			"sd_box_#{count_num}",
			"contour_record_dvr_#{count_num}",
			"contour_hd_dvr_#{count_num}",
			"contour_hd_receiver_#{count_num}",
			"mini_box_#{count_num}",
			"cable_card_#{count_num}"
		]
  end

  # this is a custom names for fields as the names are on the basis of numbers
  # e.g 'dvr_box_1', 'additional_hd_1'.
  # this method is poping the number from field name and
  # returning a different label
  def custom_tv_names(name)
    one_time_fee = ""

    name = name.split("_")
    name.pop # eliminating last elem
    name = name.join("_")

    one_time_fee = " <em>(One Time Fee)</em>" if name == "4th_tv_install"

    case name
    when "dvr_box"
      str = "Enhanced DVR Box & Service"
    when "additional_hd"
      str = "HD Box"
    when "dta"
      str = "DTA Box"
    when "4th_tv_install"
      str = "4th Outlet Activation"
    when "sd_box"
      str = "SD Box"
    when "contour_record_dvr"
      str = "Contour Record 6 HD-DVR Receiver"
    when "contour_hd_dvr"
      str = "Contour HD-DVR Receiver"
    when "contour_hd_receiver"
      str = "Contour HD Receiver"
    when "mini_box"
      str = "Mini Box"
    when "cable_card"
      str = "Cable Card"
    end

    (str + one_time_fee).html_safe
  end

  def channel_provider_names(provider)
    if provider == Provider::TIME_WARNER
      "twc"
    elsif provider == Provider::CHARTER_SPECTRUM
      "charter_spectrum"
    else
      "cox"
    end
  end
end
