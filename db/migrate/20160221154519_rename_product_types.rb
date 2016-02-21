class RenameProductTypes < ActiveRecord::Migration
  def self.up
  	rename_table :product_types, :products
  end
  def self.down
  	rename_table :products, :product_types
  end
end
