class AddDisplayModeToScreens < ActiveRecord::Migration[8.0]
  def change
    add_column :screens, :display_mode, :string
  end
end
