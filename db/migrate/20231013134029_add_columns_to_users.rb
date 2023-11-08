class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_work_time, :time, default: Time.current.change(hour: 8, min: 0, sec: 0)
  end
end
