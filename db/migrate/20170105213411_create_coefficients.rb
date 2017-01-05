class CreateCoefficients < ActiveRecord::Migration[5.0]
  def change
    create_table :coefficients do |t|
      t.string :percent
      t.references :spell, foreign_key: true

      t.timestamps
    end
  end
end
