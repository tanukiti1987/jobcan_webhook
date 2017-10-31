class CreateAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications do |t|
      t.string :client_name, null: false
      t.string :user_name,   null: false
      t.string :password,    null: false
      t.string :salt,        null: false
      t.string :uuid,        null: false

      t.timestamps
    end
  end
end
