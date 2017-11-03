class CreateSlackNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_notifications do |t|
      t.integer :authentication_id, null: false
      t.string :webhook_url,        null: false
      t.string :channel,            null: false

      t.timestamps
    end
  end
end
