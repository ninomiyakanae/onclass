class AddSuperiorMonthNoticeConfirmationToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :superior_month_notice_confirmation, :integer
  end
end
