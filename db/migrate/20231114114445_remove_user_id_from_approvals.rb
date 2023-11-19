class RemoveUserIdFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :user_id, :integer
  end
end
