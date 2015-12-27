class AddDrawToGames < ActiveRecord::Migration
  def up
    add_column  :games, :draw, :boolean, default: false
  end
  def down
    remove_column  :games, :draw
  end
end
