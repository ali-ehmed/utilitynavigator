ActiveAdmin.register CallBack do
  # permit_params :email, :password, :password_confirmation
  actions :all, except: [:update, :destroy, :new, :create, :edit]
  menu priority: 2

  index do
    selectable_column
    column :email
    column :full_name do |call_back_user|
    	call_back_user.full_name
    end
    column :address
    column :zip
    column :state
    column :phone_no
    column :preferred_time
    column "Requested at" do |call_back_user|
    	call_back_user.created_at.strftime("%d %b, %Y")
    end
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :zip

end
