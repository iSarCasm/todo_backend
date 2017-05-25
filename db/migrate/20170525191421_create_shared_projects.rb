class CreateSharedProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :shared_projects do |t|
      t.references :project, foreign_key: true
      t.string :url

      t.timestamps
    end

    add_index :shared_projects, :url, unique: true
  end
end
