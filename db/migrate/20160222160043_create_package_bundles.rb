class CreatePackageBundles < ActiveRecord::Migration
  def change
    create_table :package_bundles do |t|
      t.integer :package_id
      t.integer :product_id
      t.string :field

      t.timestamps null: false
    end
  end
end
