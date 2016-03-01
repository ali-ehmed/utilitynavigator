class AddCheckoutFieldsToPackageBundles < ActiveRecord::Migration
  def change
    add_column :package_bundles, :checkout_fields, :string
  end
end
