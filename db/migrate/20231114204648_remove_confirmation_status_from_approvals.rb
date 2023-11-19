class RemoveConfirmationStatusFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :confirmation_status, :sinteger
  end
end
