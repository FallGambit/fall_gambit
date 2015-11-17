class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.integer :x_position
      t.integer :y_position
      t.string :piece_type
      t.boolean :color
      t.integer :game_id
      t.integer :user_id
      t.boolean :captured

      t.timestamps
    end
  end
end
