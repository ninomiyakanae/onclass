class AddTomorrowCheckToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :tomorrow_check, :boolean
  end
end
