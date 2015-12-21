class Game < ActiveRecord::Base
  attr_accessor :creator_plays_as_black # for checkbox access
  has_many :pieces
  belongs_to :white_user, class_name: 'User', foreign_key: :white_user_id
  belongs_to :black_user, class_name: 'User', foreign_key: :black_user_id
  validates :game_name, presence: { :message => "Game name is required!" }
  validates :white_user_id,
            presence: true, unless: :black_user_id?, on: :create
  validates :black_user_id,
            presence: true, unless: :white_user_id?, on: :create
  validate :user_id_exists, on: :create
  validate :white_user_id_exists, if: :white_user_id?, on: :update
  validate :black_user_id_exists, if: :black_user_id?, on: :update
  validate :users_must_be_different, on: :update
  validate :user_turn_must_be_valid, on: :update
  after_create :populate_board!

  # This is part of STI ~AMP:
  delegate :pawns, :queens, :kings, :knights, :rooks, :bishops, to: :pieces

  def populate_board!
    # Creates all 32 chess pieces with their initial X/Y coordinates.

    # Board is numbered as per standard. X = column, Y = row
    # Bottom (white) rows are 0 and 1, top (black) rows are 6 and 7
    # Make sure to keep this in mind when working the logic, it's set up
    # as the upper right quadrant of a graph (instead of thinking [row, column]
    # coordinates as you normally might for a matrix)
    populate_white_pieces
    populate_black_pieces
    white_user_id.nil? ? set_pieces_black_user_id : set_pieces_white_user_id
  end

  def set_pieces_black_user_id
    pieces.where(color: false).each do |curr_piece|
      curr_piece.update_attributes(user_id: black_user_id)
    end
  end

  def set_pieces_white_user_id
    pieces.where(color: true).each do |curr_piece|
      curr_piece.update_attributes(user_id: white_user_id)
    end
  end

  def set_turn_id (player_id)
    self.user_turn = player_id
    self.save!
  end

  def finish_turn(player)
    if player == black_user
      set_turn_id(white_user_id)
    else
      set_turn_id(black_user_id)
    end
  end

  def current_player
    if self.user_turn == black_user_id
      return self.black_user
    else
      return self.white_user
    end
  end

  def player_missing?
    white_user.nil? || black_user.nil?
  end

  def determine_check(king)
    opponents_pieces = pieces.where(color: !king.color, , captured: false)
    opponents_pieces.each do |piece|
      if !piece.valid_move?(king.x_position, king.y_position)
        self.update_attributes(check_status: 0)
      else
        self.update_attributes(check_status: 1)
        return true
      end
    end
    return false
  end

  def check?
    check_status == 1 ? true : false
  end

  def puts_in_check?(king, x_dest, y_dest)
    if king.valid_move?(x_dest, y_dest)
      temp_king = king.assign_attributes(x_position: x_dest, y_position: y_dest)
    else
      return false
    end
    opponents_pieces = pieces.where(color: !king.color, , captured: false)
    opponents_pieces.each do |piece|
      if piece.valid_move?(temp_king.x_position, temp_king.y_position)
        return piece # will use this for processing in checkmate method - will count as true
      end
    end
    return false
  end

  def checkmate?(king)
    return false unless determine_check(king)
    # try moving every direction to escape check, any valid move then false
    if puts_in_check?(king, king.x_position, king.y_position+1) # up
      threatening_pieces << puts_in_check?(king, king.x_position, king.y_position+1)
    else
      return false
    end
    if puts_in_check?(king, king.x_position+1, king.y_position+1) # up-right
      threatening_pieces << puts_in_check?(king, king.x_position+1, king.y_position+1)
    else
      return false
    end
    if puts_in_check?(king, king.x_position+1, king.y_position) # right
      threatening_pieces << puts_in_check?(king, king.x_position+1, king.y_position)
    else
      return false
    end
    if puts_in_check?(king, king.x_position+1, king.y_position-1) # down-right
      threatening_pieces << puts_in_check?(king, king.x_position+1, king.y_position-1)
    else
      return false
    end
    if puts_in_check?(king, king.x_position, king.y_position-1) # down
      threatening_pieces << puts_in_check?(king, king.x_position, king.y_position-1)
    else
      return false
    end
    if puts_in_check?(king, king.x_position-1, king.y_position-1) # down-left
      threatening_pieces << puts_in_check?(king, king.x_position-1, king.y_position-1)
    else
      return false
    end
    if puts_in_check?(king, king.x_position-1, king.y_position) # left
      threatening_pieces << puts_in_check?(king, king.x_position-1, king.y_position)
    else
      return false
    end
    if puts_in_check?(king, king.x_position-1, king.y_position+1) # up-left
      threatening_pieces << puts_in_check?(king, king.x_position-1, king.y_position+1)
    else
      return false
    end
    if puts_in_check?(king, king.x_position, king.y_position+1) # up
      threatening_pieces << puts_in_check?(king, king.x_position, king.y_position+1)
    else
      return false
    end
    # determine threatening piece - will be in threatening_pieces
    threatening_pieces.each do |enemy_piece|
      range_to_check = range_between_pieces(king, enemy_piece) #get x and y coord of squares between king and enemy
      friendly_pieces = pieces.where(color: king.color, captured: false)
      friendly_pieces.each do |friendly_piece|
        # can any friendly piece capture threatening piece? then false
        return false if friendly_piece.valid_move?(enemy_piece.x_position, enemy_piece.y_position)
        return true if enemy_piece.piece_type == "Knight" # can't block knight
        # can any friendly piece block check? then false
        # need to determine movement path - then see if any piece has valid move within that line
        range_to_check.each do |square|
          return false if friendly_piece.valid_move?(square[0], square[1]) #pull out x and y values to see if we can block
        end
        
      end
    end
    # otherwise, return true
    return true
  end

  def range_between_pieces(piece_one, piece_two)
    # will return an array of all x + y coords between 2 squares
    # only horizontal, vertical, and diagonal ranges are allowed (will return empty array if invalid)
    # does not include the start or end square
    position_array = []
    return position_array if piece_one == piece_two # same position
    if piece_one.x_position == piece_two.x_position #vertical
      vert_range = (piece_one.y_position..piece_two.y_position).to_a
      vert_range = vert_range[1, vert_range.length - 2] # chop off first and last element
      if piece_one.y_position > piece_two.y_position
        vert_range = vert_range.reverse
      end
      vert_range.each do |y_coord|
        position_array << [piece_one.x_position, y_coord]
      end
      return position_array
    end
    if piece_one.y_position == piece_two.y_position #horizontal
      horiz_range = (piece_one.x_position..piece_two.x_position).to_a
      horiz_range = horiz_range[1, horiz_range.length - 2] # chop off first and last element
      if piece_one.x_position > piece_two.x_position
        horiz_range = horiz_range.reverse
      end
      horiz_range.each do |x_coord|
        position_array << [x_coord, piece_one.y_position]
      end
      return position_array
    end
    if (piece_one.x_position - piece_two.x_position).abs == (piece_one.y_position - piece_two.y_position).abs #diagonal
      state_x = piece_one.x_position
      state_y = piece_one.y_position
      delta_x = piece_two.x_position - piece_one.x_position
      delta_y = piece_two.y_position - piece_one.y_position
      if delta_x == delta_y && delta_x > 0
        # NE move: positive X, positive Y diagonal
        steps = delta_x - 1
        steps.times do
          state_x += 1
          state_y += 1
          position_array << [state_x, state_y]
        end
        return position_array
      elsif delta_x == delta_y && delta_x < 0
        # SW move: negative X negative Y diagonal
        steps = delta_x.abs - 1
        steps.times do
          state_x -= 1
          state_y -= 1
          position_array << [state_x, state_y]
        end
        return position_array
      elsif delta_x > 0 && delta_y < 0 && delta_x == delta_y.abs
        # SE move: positive X, negative Y diagonal
        steps = delta_x - 1
        steps.times do
          state_x += 1
          state_y -= 1
          position_array << [state_x, state_y]
        end
        return position_array
      elsif delta_x < 0 && delta_y > 0 && delta_x.abs == delta_y
        # NW move: negative X, positive Y diagonal
        steps = delta_y - 1
        steps.times do
          state_x -= 1
          state_y += 1
          position_array << [state_x, state_y]
        end
        return position_array
      end
    end
  end

  private

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
                 color: true)
    # White King
    King.create(game_id: id, x_position: 4, y_position: 0,
                color: true)
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
                 color: false)
    # Black King
    King.create(game_id: id, x_position: 4, y_position: 7,
                color: false)
  end

  def populate_pawns(is_white)
    is_white ? pawn_y_position = 1 : pawn_y_position = 6
    (0..7).each do |a|
      Pawn.create(game_id: id, x_position: a, y_position: pawn_y_position,
                  color: is_white)
    end
  end

  def populate_knights(is_white)
    is_white ? knight_y_position = 0 : knight_y_position = 7
    Knight.create(game_id: id, x_position: 1, y_position: knight_y_position,
                  color: is_white)
    Knight.create(game_id: id, x_position: 6, y_position: knight_y_position,
                  color: is_white)
  end

  def populate_bishops(is_white)
    is_white ? bishop_y_position = 0 : bishop_y_position = 7
    Bishop.create(game_id: id, x_position: 2, y_position: bishop_y_position,
                  color: is_white)
    Bishop.create(game_id: id, x_position: 5, y_position: bishop_y_position,
                  color: is_white)
  end

  def populate_rooks(is_white)
    is_white ? rook_y_position = 0 : rook_y_position = 7
    Rook.create(game_id: id, x_position: 0, y_position: rook_y_position,
                color: is_white)
    Rook.create(game_id: id, x_position: 7, y_position: rook_y_position,
                color: is_white)
  end

  def user_id_exists
    if white_user_id? && User.find_by_id(white_user_id).nil?
      errors.add(:white_user_id, 'must be an existing user!')
    elsif black_user_id? && User.find_by_id(black_user_id).nil?
      errors.add(:black_user_id, 'must be an existing user!')
    end
  end

  def white_user_id_exists
    return unless User.find_by_id(white_user_id).nil?
    errors.add(:white_user_id, 'must be an existing user!')
  end

  def black_user_id_exists
    return unless User.find_by_id(black_user_id).nil?
    errors.add(:black_user_id, 'must be an existing user!')
  end

  def users_must_be_different
    return unless black_user_id == white_user_id
    errors.add(:base, 'White and Black users cannot be the same!')
  end

  def user_turn_must_be_valid
    return unless (user_turn != white_user_id) && (user_turn != black_user_id)
    errors.add(:user_turn, 'Current turn is neither white or black user!')
  end
end
