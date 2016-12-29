class CreateRunes < ActiveRecord::Migration[5.0]
  def change
    create_table :runes do |t|
      t.text :description
      t.string :name
      t.text :tags
      t.integer :game_num
      t.string :type2
      t.string :tier
      t.text :stats

      t.timestamps
    end
  end
end
