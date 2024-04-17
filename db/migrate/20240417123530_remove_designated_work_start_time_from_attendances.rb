class RemoveDesignatedWorkStartTimeFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :designated_work_start_time, :datetime
  end
end
