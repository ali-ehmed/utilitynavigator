class CreateCallBacks < ActiveRecord::Migration
  def change
    create_table :call_backs do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_no
      t.text :address
      t.string :state
      t.string :zip
      t.time :preferred_time

      t.timestamps null: false
    end
  end
end
