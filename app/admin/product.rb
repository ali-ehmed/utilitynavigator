ActiveAdmin.register Product do
	menu :if => proc { current_admin_user.super_admin == true } 
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
	permit_params :name,
    additional_field_weights_attributes: [:id, :additional_weight, :_destroy]

	form do |f|
    f.inputs :name

    f.has_many :additional_field_weights do |field_weight|
	    field_weight.inputs "Add Fields", :additional_weight
	  end

    f.actions
  end
end
