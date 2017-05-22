class ChangeTasksTimeToString < ActiveRecord::Migration[5.1]
  def change
    change_column :tasks, :deadline, :string
  end
end
