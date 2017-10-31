class AddSecretKeyColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :authentications, :secret_key, :string, after: :uuid

    add_index :authentications, :uuid, unique: true
  end
end