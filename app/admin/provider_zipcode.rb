ActiveAdmin.register ProviderZipcode do

	index do
    selectable_column
    column :provider
    column :zipcode
    actions
  end

  scope "TWS", :default => true do
    ProviderZipcode.time_warner_zipcodes
  end

  scope "Charter" do
    ProviderZipcode.charter_zipcodes
  end

  scope "COX" do
    ProviderZipcode.cox_zipcodes
  end

  controller do
  	def create
  		if params[:file].blank? or params[:provider_id].blank?
  			redirect_to new_admin_provider_zipcode_path, flash: { alert: "Provider and File must be selected" }
  			return
  		end
  		@provider = Provider.find(params[:provider_id])
  		ProviderZipcode.import_zipcodes(params[:file], @provider)
  		redirect_to admin_provider_zipcodes_path, notice: "Zipcodes Imported for #{@provider.name}"
  	end
  end

  form partial: 'provider_zipcode_form'
end
