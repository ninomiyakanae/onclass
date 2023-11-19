class RemoveMonthAtFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :month_at, :string
  end
end
