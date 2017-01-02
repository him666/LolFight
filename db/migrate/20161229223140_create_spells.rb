class CreateSpells < ActiveRecord::Migration[5.0]
  def change
    create_table :spells do |t|
      t.string :name
      t.text :base_dmg
      t.text :cooldown
      t.text :bonus_dmg
      t.string :effect
      t.text :description
      t.references :champion, foreign_key: true

      t.timestamps
    end
  end
end
