class CreateScreenContainers < ActiveRecord::Migration[8.0]
  def change
    create_table :screen_containers do |t|
      t.string :name

      t.timestamps
    end
  end
end
