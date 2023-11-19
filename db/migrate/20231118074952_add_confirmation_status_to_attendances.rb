class AddConfirmationStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :confirmation_status, :integer, default: 0
  end
end
