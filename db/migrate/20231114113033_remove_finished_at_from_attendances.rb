class RemoveFinishedAtFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :finished_at, :datetime
  end
end
