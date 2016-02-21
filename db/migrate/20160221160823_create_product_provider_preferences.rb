class CreateProductProviderPreferences < ActiveRecord::Migration
  def change
    create_table :product_provider_preferences do |t|
      t.integer :provider_id
      t.integer :additional_field_weight_id

      t.timestamps null: false
    end
  end
end
