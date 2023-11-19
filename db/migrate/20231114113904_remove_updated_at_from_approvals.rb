class RemoveUpdatedAtFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :updated_at, :datetime
  end
end
