class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :game_name

      t.timestamps
    end
  end
end
