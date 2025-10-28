class CreateScreens < ActiveRecord::Migration[8.0]
  def change
    create_table :screens do |t|
      t.string :name, null:false
      t.string :slug, null:false, index: { unique: true } # e.g screen1
      t.timestamps
    end
  end
end
