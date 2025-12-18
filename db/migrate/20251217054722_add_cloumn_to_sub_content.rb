class AddCloumnToSubContent < ActiveRecord::Migration[8.0]
  def change
    add_column :sub_contents, :asf_data, :json, null: true
  end
end
