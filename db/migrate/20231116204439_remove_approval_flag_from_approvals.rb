class RemoveApprovalFlagFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :approval_flag, :boolean
  end
end
