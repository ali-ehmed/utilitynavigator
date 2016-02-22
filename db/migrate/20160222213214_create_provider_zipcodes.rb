class CreateProviderZipcodes < ActiveRecord::Migration
  def change
    create_table :provider_zipcodes do |t|
      t.string :zipcode
      t.integer :provider_id

      t.timestamps null: false
    end
  end
end
