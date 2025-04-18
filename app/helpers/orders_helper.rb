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

module OrdersHelper
	def status_label(status)
		case status
		when "pending"
			"warning"
		when "declined"
			"danger"
		else
			"success"
		end
	end
end
