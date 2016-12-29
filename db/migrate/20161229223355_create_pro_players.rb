class CreateProPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :pro_players do |t|
      t.string :name
      t.integer :game_num
      t.string :tier
      t.integer :games
      t.string :most_played

      t.timestamps
    end
  end
end
