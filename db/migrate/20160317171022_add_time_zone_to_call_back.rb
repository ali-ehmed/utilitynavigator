class AddTimeZoneToCallBack < ActiveRecord::Migration
  def change
    add_column :call_backs, :time_zone, :string
  end
end
