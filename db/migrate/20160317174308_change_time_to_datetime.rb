class ChangeTimeToDatetime < ActiveRecord::Migration
  def up
  	# remove_column :call_backs, :preferred_time
    # add_column :call_backs, :preferred_time, :time
  end

  def down
  	remove_column :call_backs, :preferred_time
    # add_column :call_backs, :preferred_time, :time
  end
end
