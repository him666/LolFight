class CreateChampions < ActiveRecord::Migration[5.0]
  def change
    create_table :champions do |t|
      t.string :name
      t.string :title
      t.integer :game_num
      t.text :tags
      t.text :stats
      t.text :block_items
      t.string :basic_dmg
      t.text :passive
      t.text :lore

      t.timestamps
    end
  end
end
