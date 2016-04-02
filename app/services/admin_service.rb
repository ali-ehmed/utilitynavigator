class AdminService
  def call
    admin = AdminUser.find_or_create_by!(email: "khurram.chaudhry@excelsteer.com") do |admin|
      admin.password = "BeHappy2016"
      admin.password_confirmation = "BeHappy2016"
      admin.super_admin = false
    end

    # Developers
    admin = AdminUser.find_or_create_by!(email: "developers@designhenge.com") do |admin|
      admin.password = "testing123"
      admin.password_confirmation = "testing123"
      admin.super_admin = true
    end
  end
end
