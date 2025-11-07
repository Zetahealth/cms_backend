class AddHyperlinkToContents < ActiveRecord::Migration[8.0]
  def change
    add_column :contents, :hyperlink, :string
  end
end
