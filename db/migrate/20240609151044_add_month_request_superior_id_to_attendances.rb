class AddMonthRequestSuperiorIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_request_superior_id, :integer
  end
end
