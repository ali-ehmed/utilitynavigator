# == Schema Information
#
# Table name: call_backs
#
#  id             :integer          not null, primary key
#  first_name     :string
#  last_name      :string
#  email          :string
#  phone_no       :string
#  address        :text
#  state          :string
#  zip            :string
#  preferred_time :time
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class CallBack < ActiveRecord::Base

	validates :first_name, :last_name, :email, :address, :phone_no, :state, :zip, :preferred_time, presence: true
	validates_format_of :email,:with => Devise::email_regexp

	SUCCESS = "Thank you for requesting a call. Our provider soon will contact you on your entered phone number."
	after_create :notify_admin

	def full_name
		"#{first_name} #{last_name}"
	end

	def notify_admin
		RequestCallBack.call_request.deliver_now!
	end
end
