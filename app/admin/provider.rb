ActiveAdmin.register Provider do

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

	controller do
		def edit
			@provider = Provider.find(params[:id])
		end

		def update
			@provider = Provider.find(params[:id])
			if @provider.update_attributes(provider_params)
				redirect_to admin_providers_path, notice: "Provider Updated"
			else
				flash[:alert] = "Please review errors"
				render :edit
			end
		end

		private

		def provider_params
			params.require(:provider).permit(:name, :additional_field_weight_ids => [])
		end
	end

	show do
		attributes_table do
			row :name

			panel 'Preferences' do
				attributes_table_for provider do 
					provider.product_provider_preferences.each do |pref|
						row "Field for #{pref.additional_field_weight.product.name.humanize}" do
							pref.additional_field_weight.additional_weight
						end
					end
				end
			end
		end
	end


	form do |f|
    f.inputs :name

    f.input :additional_field_weight_ids, label: "Additional Preferences", as: :check_boxes, collection: AdditionalFieldWeight.all.map{|m| ["#{m.additional_weight} - (#{m.product.name.humanize})", m.id]}, :input_html => { :checked => false }

    f.actions
  end
end
