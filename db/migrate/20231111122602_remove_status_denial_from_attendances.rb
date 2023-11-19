class RemoveStatusDenialFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :status_denial, :string
  end
end
