# == Schema Information
#
# Table name: orders
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
#  total_cost        :float            default(0.0)
#  status            :integer          default(0)
#

class Order < ActiveRecord::Base
	belongs_to :user
	accepts_nested_attributes_for :user

	belongs_to :package

	# validates :card_last4, :card_exp_year, :card_exp_month, :security_code, presence: true, if: :payment_after_install
	# validates :card_last4, format: { :with => /[\d-]/, message: "must be like 99999-9999-9999-9" }, if: :payment_after_install

	after_create :send_admin_notification, :send_user_notification

	enum :status => { pending: 0, approved: 1, declined: 2 }

	validates_length_of :card_last4, :minimum => 14, :maximum => 16, if: :payment_after_install

	validates_length_of :card_exp_month, :minimum => 1, :maximum => 12, if: :payment_after_install

	validate :validate_agreement
	# after_initialize :default_fields

	def render_order_step
		'offers/checkout/reserve_order'
	end

	attr_accessor :security_code, :pay_at_installation, :user_agreement

	def payment_after_install
		if self.pay_at_installation == "false"
			true
		end
	end

	def validate_agreement
    if self.user_agreement == "false"
      self.errors[:base] << "You must accept the Terms of use & Privacy Policy"
    end
  end

	RESERVED_MESSAGE = "<strong>Dear User!</strong> <p> Your order has been placed. Utility Navigators will be contacting you. </p> Thank You".html_safe

	def send_admin_notification
		Checkout.notify_admin(self).deliver_now!
	end

	def send_user_notification
		Checkout.notify_user(self, self.user).deliver_now!
	end

	def default_fields
		self.pay_at_installation = false
	end
end
