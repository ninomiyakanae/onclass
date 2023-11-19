class RemoveStartedAtFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :started_at, :datetime
  end
end
