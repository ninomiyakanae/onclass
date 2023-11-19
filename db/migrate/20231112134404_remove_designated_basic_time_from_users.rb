class RemoveDesignatedBasicTimeFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :basic_time, :time
  end
end
