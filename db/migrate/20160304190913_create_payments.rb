class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :package_id
      t.string :extra_equiptments
      t.string :card_last4
      t.integer :card_exp_month
      t.integer :card_exp_year
      t.string :card_type

      t.timestamps null: false
    end
  end
end
