class RemoveStatusNoneFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :status_none, :string
  end
end
