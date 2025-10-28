class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string :title
      t.string :content_type # "video" or "image" or "html" etc
      t.text :metadata # json as text (optional)
      t.timestamps
    end
  end
end
