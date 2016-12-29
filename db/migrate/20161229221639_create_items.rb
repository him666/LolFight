class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.text :tags
      t.integer :game_num
      t.text :description
      t.text :plaintext
      t.text :stats
      t.string :name
      t.integer :gold
      t.integer :sell_price

      t.timestamps
    end
  end
end
