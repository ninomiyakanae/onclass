class AddOverToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_check, :datetime
    add_column :attendances, :confirmation, :string
    add_column :attendances, :attendance_change_check, :boolean
    add_column :attendances, :attendance_change_flag, :boolean
  end
end
