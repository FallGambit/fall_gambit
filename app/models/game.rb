class Game < ActiveRecord::Base
  attr_accessor :creator_plays_as_black  # for checkbox access
  has_many :pieces, dependent: :destroy
  belongs_to :white_user, class_name: 'User', foreign_key: :white_user_id
  belongs_to :black_user, class_name: 'User', foreign_key: :black_user_id
  validates :game_name, presence: { :message => "Game name is required!" }
  validates :white_user_id, presence: true, unless: :black_user_id?, on: :create
  validates :black_user_id, presence: true, unless: :white_user_id?, on: :create
  validate :user_id_exists, on: :create
  validate :white_user_id_exists, if: :white_user_id?, on: :update
  validate :black_user_id_exists, if: :black_user_id?, on: :update
  validate :users_must_be_different, on: :update
  after_create :populate_board!

  # This is part of STI ~AMP:
  delegate :pawns, :queens, :kings, :knights, :rooks, :bishops, to: :pieces

  def user_id_exists
    if white_user_id? && User.find_by_id(white_user_id).nil?
      errors.add(:white_user_id, 'must be an existing user!')
    elsif black_user_id? && User.find_by_id(black_user_id).nil?
      errors.add(:black_user_id, 'must be an existing user!')
    end
  end

  def white_user_id_exists
    if User.find_by_id(white_user_id).nil?
      errors.add(:white_user_id, 'must be an existing user!')
    end
  end

  def black_user_id_exists
    if User.find_by_id(black_user_id).nil?
      errors.add(:black_user_id, 'must be an existing user!')
    end
  end

  def users_must_be_different
    if white_user_id.nil?
      errors.add( :white_user_id, 'cannot be the same user as Black!' ) if white_user_id == black_user_id
    else
      errors.add( :black_user_id, 'cannot be the same user as White!' ) if black_user_id == white_user_id
    end
  end

  def populate_board!
    # Creates all 32 chess pieces with their initial X/Y coordinates.

    # Board is numbered as per standard. X = column, Y = row
    # Bottom (white) rows are 0 and 1, top (black) rows are 6 and 7
    # Make sure to keep this in mind when working the logic, it's set up
    # as the upper right quadrant of a graph (instead of thinking [row, column]
    # coordinates as you normally might for a matrix)
    populate_white_pieces
    populate_black_pieces
  end

  def populate_white_pieces
    # Create white pieces (color == true for white):
    # White Pawns
    populate_pawns(true)
    # White Knights
    populate_knights(true)
    # White Bishops
    populate_bishops(true)
    # White Rooks
    populate_rooks(true)
    # White Queen
    Queen.create(game_id: id, x_position: 3, y_position: 0,
                 color: true, user_id: white_user)
    # White King
    King.create(game_id: id, x_position: 4, y_position: 0,
                color: true, user_id: white_user)
  end

  def populate_black_pieces
    # Create black pieces (color == false for black):
    # Black Pawns
    populate_pawns(false)
    # Black Knights
    populate_knights(false)
    # Black Bishops
    populate_bishops(false)
    # Black Rooks
    populate_rooks(false)
    # Black Queen
    Queen.create(game_id: id, x_position: 3, y_position: 7,
                 color: false, user_id: nil)
    # Black King
    King.create(game_id: id, x_position: 4, y_position: 7,
                color: false, user_id: nil)
  end

  def populate_pawns(is_white)
    is_white ? pawn_y_position = 1 : pawn_y_position = 6
    is_white ? curr_user = white_user : curr_user = nil
    (0..7).each do |a|
      Pawn.create(game_id: id, x_position: a, y_position: pawn_y_position,
                  color: is_white, user_id: curr_user)
    end
  end

  def populate_knights(is_white)
    is_white ? knight_y_position = 0 : knight_y_position = 7
    is_white ? curr_user = white_user : curr_user = nil
    Knight.create(game_id: id, x_position: 1, y_position: knight_y_position,
                  color: is_white, user_id: curr_user)
    Knight.create(game_id: id, x_position: 6, y_position: knight_y_position,
                  color: is_white, user_id: curr_user)
  end

  def populate_bishops(is_white)
    is_white ? bishop_y_position = 0 : bishop_y_position = 7
    is_white ? curr_user = white_user : curr_user = nil
    Bishop.create(game_id: id, x_position: 2, y_position: bishop_y_position,
                  color: is_white, user_id: curr_user)
    Bishop.create(game_id: id, x_position: 5, y_position: bishop_y_position,
                  color: is_white, user_id: curr_user)
  end

  def populate_rooks(is_white)
    is_white ? rook_y_position = 0 : rook_y_position = 7
    is_white ? curr_user = white_user : curr_user = nil
    Rook.create(game_id: id, x_position: 0, y_position: rook_y_position,
                color: is_white, user_id: curr_user)
    Rook.create(game_id: id, x_position: 7, y_position: rook_y_position,
                color: is_white, user_id: curr_user)
  end
end
