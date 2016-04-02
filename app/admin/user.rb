ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation
  menu priority: 1

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    # column :confirm_user do |user|
    #   if user.confirmed?status_tag 'active', :ok, label: 'Confirmed'
    #     
    #   else
    #     link_to "Confirm", confirm_user_admin_user_path(user), method: :put, data: { confirm: "Confirm this user?" }
    #   end
    # end
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  member_action :confirm_user, method: :put do
    resource.confirm!
    redirect_to admin_users_path, notice: "#{resource.email} has been confirmed!"
  end

end
