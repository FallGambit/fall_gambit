class AlterGamesAddDrawRequest < ActiveRecord::Migration
  def change
    add_column :games, :draw_request, :integer
  end
end
