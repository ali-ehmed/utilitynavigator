class RemoveInstallationsFromPackage < ActiveRecord::Migration
  def self.up
    remove_column :packages, :installation_price
    remove_column :packages, :self_installation
  end

  def self.down
    remove_column :packages, :installation_price, :string
    remove_column :packages, :self_installation, :boolean
  end
end
