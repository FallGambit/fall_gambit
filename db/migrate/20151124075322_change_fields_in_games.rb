class ChangeFieldsInGames < ActiveRecord::Migration
  def up
    remove_column :games, :white_user
    remove_column :games, :black_user
    add_reference :games, :white_user, index: true
    add_reference :games, :black_user, index: true
  end

  def down
    remove_column :games, :white_user
    remove_column :games, :black_user
    add_column :games, :black_user,    :integer
    add_column :games, :white_user,    :integer
  end
end
