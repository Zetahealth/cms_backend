class CreateAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :assignments do |t|
      t.references :screen, null:false, foreign_key: true
      t.references :content, null:false, foreign_key: true
      t.integer :position, default: 0
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
