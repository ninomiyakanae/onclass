class AddIndexToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_index :attendances, [:month_first_day, :user_id], unique: true
  end
end
