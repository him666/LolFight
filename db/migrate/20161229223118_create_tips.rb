class CreateTips < ActiveRecord::Migration[5.0]
  def change
    create_table :tips do |t|
      t.text :atip
      t.text :btip
      t.references :champion, foreign_key: true

      t.timestamps
    end
  end
end
