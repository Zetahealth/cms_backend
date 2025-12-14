class CreateUserLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_logs do |t|
      t.references :user, null: false, foreign_key: true   # user_id
      t.string :event_type                                 # LOGIN, USER_CREATED, UPDATE, DELETE, etc.
      t.text :details                                      # extra information
      t.string :ip_address                                 # optional: store login IP
      t.string :browser_info                               # optional: user browser/device info
      t.timestamps
    end
  end
end




