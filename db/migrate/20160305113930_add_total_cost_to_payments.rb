class AddTotalCostToPayments < ActiveRecord::Migration
  def change
  	add_column :payments, :total_cost, :integer, default: 0
  end
end
