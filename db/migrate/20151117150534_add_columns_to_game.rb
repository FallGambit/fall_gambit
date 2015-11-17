class AddColumnsToGame < ActiveRecord::Migration
  def change
    add_column :games, :user_turn,     :integer
    add_column :games, :check_status,  :integer
    add_column :games, :black_user,    :integer
    add_column :games, :white_user,    :integer
    add_column :games, :game_id,       :integer
  end
end
