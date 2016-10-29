class AddSelfInstallationToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :self_installation, :boolean
  end
end
