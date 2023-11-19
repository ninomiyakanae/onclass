class RemoveUpdatedAtFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :updated_at, :datetime
  end
end
