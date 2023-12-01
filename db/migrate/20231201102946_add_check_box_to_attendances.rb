class AddCheckBoxToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :check_box, :boolean, default: false
  end
end
