class User < ActiveRecord::Base
  has_many :pieces
  has_many :games, :through => :pieces
  has_many :games_as_white_player, class_name: 'Game', foreign_key: :white_user_id
  has_many :games_as_black_player, class_name: 'Game', foreign_key: :black_user_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # This is part of STI ~AMP:
  delegate :pawns, :queens, :kings, :knights, :rooks, :bishops, to: :pieces
end
