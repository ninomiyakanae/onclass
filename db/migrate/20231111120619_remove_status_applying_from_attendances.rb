class RemoveStatusApplyingFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :status_applying, :string
  end
end
