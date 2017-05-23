class AddAasmToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :aasm_state, :string
  end
end
