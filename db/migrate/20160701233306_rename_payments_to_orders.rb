class RenamePaymentsToOrders < ActiveRecord::Migration
  def self.up
    rename_table :payments, :orders
  end

  def self.down
    rename_table :orders, :payments
  end
end
