ActiveAdmin.register AdditionalFieldWeight do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

	permit_params :additional_weight, :product_id, :field_type, :checkout, :value

	form do |f|
    inputs 'Details' do
      input :product
      input :additional_weight
      input :field_type

    end
    panel 'Note' do
      "The value is used based on additional field type. If multiple then you set multi comma seperated values."
    end
    inputs 'Content', :value
    # para "Press cancel to return to the list without saving."
    actions
  end
end
