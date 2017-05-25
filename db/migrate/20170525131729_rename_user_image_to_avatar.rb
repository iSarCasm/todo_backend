class RenameUserImageToAvatar < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :image, :avatar
  end
end
