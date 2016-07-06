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
  def custom_tv_names(name, price)
    is_monthly = "Monthly"

    name = name.split("_")
    name.pop # eliminating last elem
    name = name.join("_")

    is_monthly = "" if name == "4th_tv_install"

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

    if price.is_number?
      price_value = number_to_currency(price) + " " + is_monthly
    else
      price_value = "Included"
    end
    return "#{str} (#{price_value})"
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

  def fields_editing_html form, field_key, field_val, checkout_fields = {}
    selected_option = ""
    text_box_value = ""
    hidden_class = "display:none;"
    html = ""

    html = %{
      <label for="#{field_key}" class="label">
        #{field_key.humanize}
      </label>
    }

    selected_option = selected_option_of_fields(field_val)

    if select_options_non_subfields.map(&:last).include?(selected_option)
      if selected_option == "Add Price"
        hidden_class = ""
        text_box_value = field_val
      end

      html << %{
        #{form.select "checkout_select", options_for_select(select_options_non_subfields, selected_option), {prompt: "--Select--"}, class: "package_select_field", onchange: "$packages.addPriceField(this);"}
        #{form.text_field field_key.to_s, style: "#{hidden_class}width: calc(78% - 22px);", onblur: "$packages.packagePriceValidation(this);", class: "admin_checkout_price", value: text_box_value}
      }
    elsif select_options_subfields.map(&:last).include?(selected_option)

      hash_field_name, hash_field_value = find_hash_values_from_fields(field_key, checkout_fields)

      if selected_option == "Required"
        hidden_class =  ""
      end

      html << %{
        #{form.select field_key.to_s, options_for_select(select_options_subfields, field_val), {prompt: "--Select--"}, class: "package_select_field", onchange: "$packages.setRequiredFields(this);"}
      }
      if hash_field_value.present?
        form.fields_for hash_field_name.to_sym do |nested_form|
          html << %{ </li> }
          html << %{ <li style="#{hidden_class}"> }
          html << %{
            <legend><span>Set items for #{hash_field_name.humanize}</span></legend>
          }
          html << %{ <ol> }

          hash_field_value.each do |nested_field_key, nested_field_value|
            html << %{
              <li>
                #{fields_editing_html(nested_form, nested_field_key, nested_field_value)}
              </li>
            }
          end

          html << %{ </ol> }
          html << %{ </li> }
        end
      end

    end

    html.html_safe
  end

  def select_options_non_subfields
    [["Include", "Included"], ["Not Include", ""], ["Add Price", "Add Price"]]
  end

  def select_options_subfields
    [["Required", "Required"], ["Not Include", "Not Include"]]
  end

  def selected_option_of_fields(field_val)
    selected_option = field_val

    if !field_val.is_a?(Hash) and selected_option.is_number?
      selected_option = "Add Price"
    end

    selected_option
  end

  def find_hash_values_from_fields(field_parent_name, checkout_fields)
    hash_values = field_parent_name.split("_")
    return {} unless field_parent_name.include?("items")

    hash_values.pop
    hash_field_name = hash_values.join("_")
    hash_field_value = checkout_fields.select {|k,v| k == hash_field_name }
    hash_field_value[hash_field_name.to_s].delete("checkout_select")

    return hash_field_name, hash_field_value[hash_field_name.to_s]
  end
end
