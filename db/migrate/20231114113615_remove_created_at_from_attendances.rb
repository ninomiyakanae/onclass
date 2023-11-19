class RemoveCreatedAtFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :created_at, :datetime
  end
end
