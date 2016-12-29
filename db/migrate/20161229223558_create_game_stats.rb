class CreateGameStats < ActiveRecord::Migration[5.0]
  def change
    create_table :game_stats do |t|
      t.references :pro_player, foreign_key: true
      t.integer :champion_num
      t.string :champion
      t.integer :minions
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :dragons
      t.integer :wards
      t.integer :vision
      t.integer :dmg_dealt

      t.timestamps
    end
  end
end
