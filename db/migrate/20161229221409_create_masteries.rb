class CreateMasteries < ActiveRecord::Migration[5.0]
  def change
    create_table :masteries do |t|
      t.integer :game_num
      t.string :ranks
      t.text :description
      t.string :name
      t.text :mastery_tree
      t.string :modifier
      t.string :mod_type

      t.timestamps
    end
  end
end
