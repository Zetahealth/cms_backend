class AddColoumnToSubContent < ActiveRecord::Migration[8.0]
  def change
    add_column :sub_contents, :individual_contents, :string
    add_column :contents, :dob, :string
    add_column :contents, :display_mode, :string
  end
end
