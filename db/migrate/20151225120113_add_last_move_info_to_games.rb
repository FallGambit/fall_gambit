class AddLastMoveInfoToGames < ActiveRecord::Migration
  def up
    add_column :games, :last_moved_piece_id, :integer
    add_foreign_key "games", "pieces", name: "games_last_moved_piece_fk", column: "last_moved_piece_id"
    add_column :games, :last_moved_prev_x_pos, :integer
    add_column :games, :last_moved_prev_y_pos, :integer
  end
  def down
    change_table :games do |t|
      t.remove_foreign_key name: "games_last_moved_piece_fk"
    end
    remove_column :games, :last_moved_piece
    remove_column :games, :last_moved_prev_x_pos
    remove_column :games, :last_moved_prev_y_pos
  end
end
