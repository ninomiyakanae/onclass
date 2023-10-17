class AddAffiliationToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :schedule, :datetime
  end
end
