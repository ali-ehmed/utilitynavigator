class ChangeTotalCostTypePayments < ActiveRecord::Migration
  def self.up
  	execute "ALTER TABLE payments ALTER total_cost TYPE float USING total_cost::float"
  end

  def self.down
  	execute "ALTER TABLE payments ALTER total_cost TYPE integer USING total_cost::int"
  end
end
