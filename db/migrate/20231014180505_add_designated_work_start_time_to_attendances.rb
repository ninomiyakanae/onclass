class AddDesignatedWorkStartTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :designated_work_start_time, :datetime
  end
end
