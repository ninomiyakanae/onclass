class AddAffiliationToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :confirm, :string
    add_column :approvals, :approval_flag, :boolean
  end
end
