class Addlane < ActiveRecord::Migration[5.0]
  def change
    add_column :champions, :lane, :string
  end
end
