# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  package_id        :integer
#  extra_equiptments :string
#  card_last4        :string
#  card_exp_month    :integer
#  card_exp_year     :integer
#  card_type         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  total_cost        :integer          default(0)
#

class Payment < ActiveRecord::Base
	belongs_to :user
	accepts_nested_attributes_for :user

	belongs_to :package

	validates :card_last4, :card_exp_year, :card_exp_month, presence: true

	after_create :send_admin_notification, :send_user_notification
	
	def render_payment_step
		'offers/checkout/payments'
	end

	RESERVED_MESSAGE = "<strong>Dear User!</strong> <p> Your order has been placed. Soon our administration will contact you. </p> Thank You".html_safe

	def send_admin_notification
		Checkout.notify_admin(self).deliver_now!
	end

	def send_user_notification
		Checkout.notify_user(self, self.user).deliver_now!
	end
end
