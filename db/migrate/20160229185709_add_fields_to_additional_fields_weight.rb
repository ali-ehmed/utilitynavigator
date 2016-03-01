class AddFieldsToAdditionalFieldsWeight < ActiveRecord::Migration
  def self.up
  	add_column :additional_field_weights, :checkout, :boolean, default: false
  	add_column :additional_field_weights, :field_type, :string
  end

  def self.down
  	remove_column :additional_field_weights, :checkout
  	remove_column :additional_field_weights, :type
  end
end
