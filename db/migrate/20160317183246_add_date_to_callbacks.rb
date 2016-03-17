class AddDateToCallbacks < ActiveRecord::Migration
  def change
    add_column :call_backs, :preferred_date, :date
  end
end
