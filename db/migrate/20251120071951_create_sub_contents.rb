class CreateSubContents < ActiveRecord::Migration[8.0]
  def change
    create_table :sub_contents do |t|
      t.string :title
      t.references :content, null: false, foreign_key: true
      t.text :description
      t.text :metadata      # optional JSON
      t.timestamps
    end
  end
end
