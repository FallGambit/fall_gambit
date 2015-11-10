class Game < ActiveRecord::Base
  validates :game_name, :presence => { :message => "Game name is required!" }
end
