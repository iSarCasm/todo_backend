class AddDescToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :desc, :text
  end
end
