# Preview all emails at http://localhost:3000/rails/mailers/checkout
class CheckoutPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/checkout/notify_admin
  def notify_admin
    Checkout.notify_admin
  end

end
