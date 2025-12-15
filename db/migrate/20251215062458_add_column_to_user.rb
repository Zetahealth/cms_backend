class AddColumnToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :permission, :string , default: "1"
  end
end
