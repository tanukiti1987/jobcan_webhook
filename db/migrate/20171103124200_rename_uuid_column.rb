class RenameUuidColumn < ActiveRecord::Migration[5.1]
  def change
    remove_index :authentications, column: :uuid

    rename_column :authentications, :uuid, :access_key
    add_index :authentications, :access_key
  end
end
