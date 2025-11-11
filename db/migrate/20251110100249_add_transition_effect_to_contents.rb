class AddTransitionEffectToContents < ActiveRecord::Migration[8.0]
  def change
    add_column :contents, :transition_effect, :string
  end
end
