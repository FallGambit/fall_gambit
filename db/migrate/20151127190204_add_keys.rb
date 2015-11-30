class AddKeys < ActiveRecord::Migration
  def up
    add_foreign_key "games", "users", name: "games_black_user_id_fk", column: "black_user_id"
    add_foreign_key "games", "users", name: "games_white_user_id_fk", column: "white_user_id"
    add_foreign_key "pieces", "games", name: "pieces_game_id_fk", dependent: :delete
    add_foreign_key "pieces", "users", name: "pieces_user_id_fk"
  end

  def down
    change_table :games do |t|
      t.remove_foreign_key name: "games_black_user_id_fk"
      t.remove_foreign_key name: "games_white_user_id_fk"
    end
    change_table :pieces do |t|
      t.remove_foreign_key :games
      t.remove_foreign_key :users
    end
  end
end
