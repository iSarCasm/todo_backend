class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :desc
      t.time :deadline
      t.references :project, foreign_key: true, index: true

      t.timestamps
    end
  end
end
