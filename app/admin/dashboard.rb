ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate", style: "margin-top: 0px;" do
        span "Welcome to your Dashboard"
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Orders" do
          # ul do
          #   Payment.all.limit(5).map do |post|
          #     li "Hello"
          #   end
          # end
          if Payment.all.present?
            table_for Payment.order("created_at desc").limit(5) do
              column :orders do |order|
                "Order ##{order.id}"
              end
              column :package_name do |order|
                link_to order.try(:package).try(:package_name), "#"
              end
              column :ordered_by do |order|
                link_to order.try(:user).try(:full_name), "#"
              end
              column :total_cost do |order|
                number_to_currency(order.total_cost)
              end
            end
            strong { link_to "View All Orders", admin_orders_path }
          else
            div class: "blank_slate_container", id: "dashboard_default_message" do
              span class: "blank_slate" do
                span "There are no recent orders"
              end
            end
          end
        end
      end

      column do
        panel "Latest Packages" do
          if Package.all.present?
            table_for Package.order("created_at desc").limit(5) do
              column :package_name
              column :price do |package|
                number_to_currency(package.price)
              end
              column :provider do |package|
                package.try(:provider).try("name")
              end
              column :package_type do |package|
                package.try(:package_type).try("name")
              end
            end
            strong { link_to "View All Packages", admin_packages_path }
          else
            div class: "blank_slate_container", id: "dashboard_default_message" do
              span class: "blank_slate" do
                span "There are no recent packages"
              end
            end
          end
        end
      end
    end

    panel "New Users" do
      if User.all.present?
        table_for User.order("created_at desc").limit(5) do
          column :full_name do |user|
            user.full_name
          end
          column :address
          column :zip_code
          column :cell_number
          column "" do |user|
            link_to "View Profile", admin_user_path(user)
          end
        end
        strong { link_to "View All Users", admin_users_path }
      else
        div class: "blank_slate_container", id: "dashboard_default_message" do
          span class: "blank_slate" do
            span "There are no users registered"
          end
        end
      end
    end

    panel "New Call Requests" do
      if CallBack.all.present?
        table_for CallBack.order("created_at desc").limit(5) do
          column :full_name do |call_back|
            call_back.full_name
          end
          column :email
          column :address
          column :zip
          column :state
        end
        strong { link_to "View All Call Back Requests", admin_call_backs_path }
      else
        div class: "blank_slate_container", id: "dashboard_default_message" do
          span class: "blank_slate" do
            span "There are no call back requests"
          end
        end
      end
    end
  end # content
end
