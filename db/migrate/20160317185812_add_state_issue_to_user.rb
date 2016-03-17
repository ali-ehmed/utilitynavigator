class AddStateIssueToUser < ActiveRecord::Migration
  def change
    add_column :users, :state_issue, :string
  end
end
