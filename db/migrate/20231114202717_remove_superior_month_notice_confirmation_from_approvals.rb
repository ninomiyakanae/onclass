class RemoveSuperiorMonthNoticeConfirmationFromApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_column :approvals, :superior_month_notice_confirmation, :integer
  end
end
