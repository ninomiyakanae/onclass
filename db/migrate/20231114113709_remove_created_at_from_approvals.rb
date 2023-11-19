class RemoveCreatedAtFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :created_at, :datetime
  end
end
