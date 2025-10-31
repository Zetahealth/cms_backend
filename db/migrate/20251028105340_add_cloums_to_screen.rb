class AddCloumsToScreen < ActiveRecord::Migration[8.0]
  def change
    add_column :contents, :content, :text
  end
end
