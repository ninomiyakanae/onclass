class RemoveConfirmFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :confirm, :string
  end
end
