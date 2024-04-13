class AddMonthFirstDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_first_day, :date
  end
end
