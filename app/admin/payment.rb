ActiveAdmin.register Payment, as: "Orders" do

	index do
    selectable_column
    column :package
    column :user do |order|
    	link_to order.user.full_name, admin_user_path(order.user)
    end
    column :total_cost
    column :provider do |order|
    	order.package.provider.name
    end

    column :package_type do |order|
    	order.package.package_type.name
    end
    
    column "Placed At" do |order|
    	order.created_at.strftime("%d-%B-%Y")
    end

    column :status do |order|
    	if order.approved?
    		status_tag 'active', :ok, label: order.status.humanize
    	elsif order.pending?
    		status_tag 'active', :ok, class: 'pending', label: order.status.humanize
  		elsif order.declined?
    		status_tag 'active', :ok, class: 'declined', label: order.status.humanize
    	end
    end
    actions defaults: false, dropdown: true do |order|
	    item "Preview", admin_order_path(order)
	    if order.approved?
    		item 'Approved', "#", style: "font-size: 14px;"
    	else
  			item 'Approve', update_order_status_admin_order_path(order, status: 1), method: :put, data: { confirm: "Approve this order?" }
    	end

    	if order.pending?
    		item 'In Pending', "#", style: "font-size: 14px;"
  		else
				item "Put in pending", update_order_status_admin_order_path(order, status: 0), method: :put, data: { confirm: "Put in pending?" }
  		end

  		if order.declined?
    		item 'Declined', "#", style: "font-size: 14px;"
    	else
    		item 'Decline', update_order_status_admin_order_path(order, status: 2), method: :put, data: { confirm: "Decline this order?" }
    	end
	  end
  end

  member_action :update_order_status, method: :put do
    resource.update_attribute(:status, params[:status].to_i)
    redirect_to admin_orders_path, notice: "Order for #{resource.user.full_name} has set to #{resource.status.humanize}"
  end
end
