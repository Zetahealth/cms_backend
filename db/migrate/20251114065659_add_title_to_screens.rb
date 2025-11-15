class AddTitleToScreens < ActiveRecord::Migration[8.0]
  def change
    add_column :screens, :title, :string
  end
end
