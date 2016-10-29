class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.string :wifi_installation
      t.string :outlet_installation
      t.string :fourth_tv_installation
      t.string :installation_price
      t.string :self_installation, :boolean
      t.integer :package_id

      t.timestamps null: false
    end
  end
end
