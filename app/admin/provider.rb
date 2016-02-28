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

	index do
    selectable_column
    column :name
    column :created_at
    actions
  end

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
			params.require(:provider).permit(:name, :logo, :additional_field_weight_ids => [])
		end
	end

	show do
		attributes_table do
			row :name

			row :logo do
				if provider.logo.present?
        	image_tag provider.logo.url(:thumb)
        else
        	"N/A"
        end
      end

			Product.only_preferenced.each do |product|
				panel "Preferences for #{product.name.humanize}" do
					provider.product_provider_preferences.each do |pref|
						columns do
							if product.id == pref.additional_field_weight.product.id
								column max_width: "50px", min_width: "50px" do
							    span "-"
							  end
						  	column do
									span pref.additional_field_weight.additional_weight
								end
						  end
						end
					end
				end
			end
		end
	end


	form do |f|
    f.inputs :name

    f.inputs :logo

    field_weights_ids = f.object.additional_field_weight_ids || resource.product_provider_preferences.map(&:additional_field_weight_id).map(&:to_s)
    f.inputs "Additional Preferences" do
  		f.input :additional_field_weight_ids, label: "Select Preferences", as: :check_boxes, collection: AdditionalFieldWeight.all.map{|m| ["#{m.additional_weight} - (#{m.product.name.humanize})", m.id, {:checked => field_weights_ids.reject { |c| c.empty? }.map(&:to_i).include?(m.id)}]}
    end

    f.actions
  end
end
