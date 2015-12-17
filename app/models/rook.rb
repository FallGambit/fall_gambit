class Rook < Piece
  def valid_move?(x, y)
    dest_piece = game.pieces
                 .where("x_position = ? AND y_position = ?", x, y)
                 .take
    return false if is_obstructed?(x, y)
    return false if x < 0 || x > 7 || y < 0 || y > 7
    return false if dest_piece && dest_piece.color == color
    x == x_position || y == y_position
  end
end
