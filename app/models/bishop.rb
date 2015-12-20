class Bishop < Piece
  def valid_move?(dest_x, dest_y)
    # can only move diagonally
    dest_piece = game.pieces
                 .where("x_position = ? AND y_position = ?", dest_x, dest_y)
                 .take
    return false if is_obstructed?(dest_x, dest_y)
    return false if dest_x < 0 || dest_x > 7 || dest_y < 0 || dest_y > 7
    return false if dest_piece && dest_piece.color == color
    (x_position - dest_x).abs == (y_position - dest_y).abs
  end
end
