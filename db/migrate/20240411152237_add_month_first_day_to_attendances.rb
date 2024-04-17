class AddMonthFirstDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_first_day, :date
    add_column :attendances, :month_request_status, :string, default: 'なし'
  end
end
