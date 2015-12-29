class Pawn < Piece
  def valid_move?(dest_x, dest_y)
    dest_piece = game.pieces
                 .where("x_position = ? AND y_position = ?", dest_x, dest_y)
                 .take
    return false if is_obstructed?(dest_x, dest_y)
    return false if dest_x < 0 || dest_x > 7 || dest_y < 0 || dest_y > 7
    return false if dest_piece && dest_piece.color == color
    (one_forward(dest_x, dest_y) && dest_piece.nil?) ||
    (two_forward(dest_x, dest_y) && dest_piece.nil?) ||
    (one_diagonal(dest_x, dest_y) && !dest_piece.nil?)
  end

  def promote!(type)
    # change piece type
    # can't swap for another pawn or king
    return false unless type == "Queen" || type == "Knight" || type == "Rook" || type == "Bishop"
    # must be on last row on other side of board
    return false unless promote?
    self.piece_type = type
    self.set_image
    self.save
    return true
  end

  def promote?
    # pawn must be on last row of other side
    if white_moving
      return false unless y_position == 7
    else
      return false unless y_position == 0
    end
    return true
  end

  def promote_at?(dest_x, dest_y)
    # pawn must reach last row of other side
    if white_moving
      return false unless dest_y == 7 && valid_move?(dest_x, dest_y)
    else
      return false unless dest_y == 0 && valid_move?(dest_x, dest_y)
    end
    return true
  end

  def white_moving
    color
  end

  def one_forward(dest_x, dest_y)
    if white_moving
      dest_x == x_position && dest_y == y_position + 1
    else
      dest_x == x_position && dest_y == y_position - 1
    end
  end

  def two_forward(dest_x, dest_y)
    if white_moving
      y_position == 1 && dest_x == x_position && dest_y == y_position + 2
    else
      y_position == 6 && dest_x == x_position && dest_y == y_position - 2
    end
  end

  def one_diagonal(dest_x, dest_y)
    if white_moving
      dest_y == y_position + 1 && (dest_x == x_position + 1 || dest_x == x_position - 1)
    else
      dest_y == y_position - 1 && (dest_x == x_position + 1 || dest_x == x_position - 1)
    end
  end
end
