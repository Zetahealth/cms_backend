class AddColoumnToContent < ActiveRecord::Migration[8.0]
  def change
    add_column :contents, :view_mode, :string
  end
end
