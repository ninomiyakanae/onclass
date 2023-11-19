class AddMonthAtToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :month_at, :datetime
  end
end
