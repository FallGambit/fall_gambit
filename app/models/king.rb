class King < Piece
  def valid_move?(x, y)
    rows = (y - y_position).abs
    columns = (x - x_position).abs
    rows <= 1 && columns <= 1 ? true : false
  end

  # make sure when castling to update has_moved to true for both pieces!
  def can_castle?(rook) # pass in rook object
    return false unless initial_state?(rook)
    # other piece must be a rook of same color as king
    return false unless friendly_rook?(rook)
    # can't castle if king is in check - placeholder method
    # return false if this.in_check? <-- uncomment when implemented!
    # pieces between rook and king must be empty
    return false if is_obstructed?(rook.x_position, rook.y_position)
    # can't pass through or end in check
    return false if puts_in_check?(rook)
    true
  end

  def initial_state?(rook)
    # can't castle if king moved
    return false if has_moved?
    # can't castle if rook moved
    return false if rook.has_moved?
    # must both be on starting row
    return false unless on_starting_row?(rook)
    true
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
    first || second
  end

  def friendly_rook?(rook)
    if rook.is_a?(Rook) && (rook.game == game)
      (rook.piece_type == 'Rook') && (rook.color == color)
    else
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
    rook.y_position < y_position
  end

  def check?(_x, _y)
    # placeholder method
    false
  end
end
