class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :zip_code, :string
    add_column :users, :cell_number, :string
    add_column :users, :home_number, :string
    add_column :users, :driver_license, :string
    add_column :users, :social_security, :string
    add_column :users, :four_digit_no, :string
    add_column :users, :date_of_birth, :date
  end
end
