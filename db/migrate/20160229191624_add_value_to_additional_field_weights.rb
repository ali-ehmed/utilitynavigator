class AddValueToAdditionalFieldWeights < ActiveRecord::Migration
  def change
    add_column :additional_field_weights, :value, :string
  end
end
