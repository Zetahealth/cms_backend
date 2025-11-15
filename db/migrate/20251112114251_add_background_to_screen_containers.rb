class AddBackgroundToScreenContainers < ActiveRecord::Migration[8.0]
  def change
    add_column :screen_containers, :background, :string
    add_column :screen_containers, :files, :string
    add_column :screen_containers, :content_type, :string
    add_column :screen_containers, :transition_effect, :string
    add_column :screen_containers, :display_mode, :string
  end
end
