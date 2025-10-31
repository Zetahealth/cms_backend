class CreateScreenContainerAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :screen_container_assignments do |t|
      t.references :screen_container, null: false, foreign_key: true
      t.references :screen, null: false, foreign_key: true

      t.timestamps
    end
  end
end
