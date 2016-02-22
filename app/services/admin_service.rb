class AdminService
  def call
    admin = AdminUser.find_or_create_by!(email: "admin@example.com") do |admin|
      admin.password = "admin123"
      admin.password_confirmation = "admin123"
    end
  end
end
