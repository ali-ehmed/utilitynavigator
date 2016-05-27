class AddFieldsToPackage < ActiveRecord::Migration
  def change
  	add_column :packages, :protection_plan_service, :string
  	add_column :packages, :lock_rates_agreement, :string
  end
end
