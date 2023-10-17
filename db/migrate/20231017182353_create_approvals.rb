class CreateApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :approvals do |t|

      t.timestamps
    end
  end
end
