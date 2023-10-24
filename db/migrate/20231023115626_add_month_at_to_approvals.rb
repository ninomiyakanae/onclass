class AddMonthAtToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :month_at, :datetime
    add_column :approvals, :user_id, :integer
  end
end
