class King < Piece
  def valid_move?(dest_x, dest_y)
    rows = (dest_y - y_position).abs
    columns = (dest_x - x_position).abs
    dest_piece = game.pieces
                 .where("x_position = ? AND y_position = ?", dest_x, dest_y)
                 .take
    return false if dest_x < 0 || dest_x > 7 || dest_y < 0 || dest_y > 7
    return false if dest_piece && dest_piece.color == color
    rows <= 1 && columns <= 1 ? true : false
  end

  def castle!(rook)
    # will return true if castling was successful. false otherwise.
    return false unless can_castle?(rook)
    if queenside?(rook)
      update_attributes(x_position: 2, has_moved: true)
      rook.update_attributes(x_position: 3, has_moved: true)
      return true
    else # has to be kingside
      update_attributes(x_position: 6, has_moved: true)
      rook.update_attributes(x_position: 5, has_moved: true)
      return true
    end
  end

  def can_castle?(rook) # pass in rook object
    # other piece must be a rook of same color as king
    return false unless friendly_rook?(rook)
    # king/rook must not have moved
    return false unless initial_state?(rook)
    # can't castle if king is in check - placeholder method
    # return false if this.in_check? <-- uncomment when implemented!
    # pieces between rook and king must be empty
    return false if is_obstructed?(rook.x_position, rook.y_position)
    # can't pass through or end in check
    return false if puts_in_check?(rook)
    true # castle move is valid!
  end

  def initial_state?(rook)
    # can't castle if king moved
    if has_moved?
      self.flash_message = "Can't castle! King already moved!"
      return false 
    end
    # can't castle if rook moved
    if rook.has_moved?
      self.flash_message = "Can't castle! Rook already moved!"
      return false 
    end
    # must both be on starting row
    unless on_starting_row?(rook)
      self.flash_message = "Can't castle! Both King and Rook must be in starting positions!"
      return false 
    end
    true #all initial state checks passed
  end

  def puts_in_check?(rook)
    if queenside?(rook) # rook on queenside
      first_y_space = -1 # move left one
      second_y_space = -2 # move left two
    else # rook on kingside - checked they didn't move in castle method
      first_y_space = 1 # move right one
      second_y_space = 2 # move right two
    end
    # placeholder method to see if square is in check
    first = check?(y_position + first_y_space, x_position)
    second = check?(y_position + second_y_space, x_position)
    if (first || second)
      self.flash_message = "Cannot move King into check while castling!"
      return false
    end
  end

  def friendly_rook?(rook)
    if rook.is_a?(Rook) && (rook.game == game)
      (rook.piece_type == 'Rook') && (rook.color == color)
    else
      self.flash_message = "Must target a friendly Rook to castle!"
      return false
    end
  end

  def on_starting_row?(rook)
    if color # white king
      return (y_position == 0) && (rook.y_position == 0)
    else
      return (y_position == 7) && (rook.y_position == 7)
    end
  end

  def queenside?(rook)
    rook.x_position < x_position
  end

  def check?(x, y)
    # placeholder method
    false
  end
end
