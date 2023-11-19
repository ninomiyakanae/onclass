class RemoveStatusApplyingFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :status_applying, :string
  end
end
