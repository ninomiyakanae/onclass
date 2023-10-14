class AddDesignatedWorkEndTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :designated_work_end_time, :datetime
  end
end
