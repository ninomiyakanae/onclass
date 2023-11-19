class RemoveStatusApprovalFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :status_approval, :string
  end
end
