class AddConfirmationStatusToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :confirmation_status, :integer
  end
end
