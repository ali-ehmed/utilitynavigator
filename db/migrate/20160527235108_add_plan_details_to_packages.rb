class AddPlanDetailsToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :plan_details, :text
  end
end
