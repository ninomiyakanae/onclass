class RemoveSuperiorIdFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :superior_id, :integer
  end
end
