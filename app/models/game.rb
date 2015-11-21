class Game < ActiveRecord::Base
	has_many :pieces
	has_many :users, :through => :pieces

	validates :game_name, :presence => { :message => "Game name is required!" }

	# This is part of STI ~AMP:
	delegate :pawns, :queens, :kings, :knights, :rooks, :bishops, to: :pieces
end
