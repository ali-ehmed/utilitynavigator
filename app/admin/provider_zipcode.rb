ActiveAdmin.register ProviderZipcode do
  menu :if => proc { current_admin_user.super_admin == true } 
  
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
  		if (params[:zipcode].blank? and params[:file].blank?) or params[:provider_id].blank?
        render :json => { status: :alert, url: new_admin_provider_zipcode_path, msg: "Provider and File must be selected" }
  			return
  		end

      if (params[:zipcode].present? and params[:file].present?)
        render :json => { status: :alert, url: new_admin_provider_zipcode_path, msg: "Either enter a zipcode or upload a zipcode document" }
        return
      end

      @provider = Provider.find(params[:provider_id])

      if params[:zipcode].present?
        provider_zipcode = @provider.provider_zipcodes.find_by(zipcode: params[:zipcode]) || @provider.provider_zipcodes.build(:zipcode => params[:zipcode])
  		  provider_zipcode.save
      else
        ProviderZipcode.import_zipcodes(params[:file], @provider)
      end

      render :json => { status: :notice, url: admin_provider_zipcodes_path, msg: "Zipcodes Imported for #{@provider.name}" }
  	end
  end

  form partial: 'provider_zipcode_form'
end
