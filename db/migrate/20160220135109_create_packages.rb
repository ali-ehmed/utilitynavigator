class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :provider_id
      t.integer :package_type_id
      t.string :package_name
      t.text :package_description
      t.string :price_info
      t.string :price
      t.string :monthly_fee_after_promotion
      t.string :installation_price
      t.string :promotion_disclaimer

      t.timestamps null: false
    end
  end
end
