class CreateSumSpells < ActiveRecord::Migration[5.0]
  def change
    create_table :sum_spells do |t|
      t.integer :game_num
      t.text :description
      t.string :name
      t.string :gkey
      t.string :buff
      t.string :percent_or_num
      t.string :cooldown

      t.timestamps
    end
  end
end
