class RemoveApprovalFlagFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :approval_flag, :boolean
  end
end
