class AddPromotionsToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :promotions, :text
  end
end
