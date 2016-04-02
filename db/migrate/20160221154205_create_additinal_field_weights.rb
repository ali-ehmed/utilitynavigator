class CreateAdditinalFieldWeights < ActiveRecord::Migration
  def change
    create_table :additional_field_weights do |t|
      t.integer :product_id
      t.string :additional_weight

      t.timestamps null: false
    end
  end
end
