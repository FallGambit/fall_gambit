class AddForfeitToGames < ActiveRecord::Migration
  def up
    add_column :games, :forfeit, :boolean, default: false
  end
  def down
    remove_column :games, :forfeit, :boolean
  end
end
