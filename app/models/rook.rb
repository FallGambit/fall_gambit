class Rook < Piece
  def valid_move?(dest_x, dest_y)
    dest_piece = self.game.pieces
                 .where("x_position = ? AND y_position = ?", dest_x, dest_y)
                 .take
    return false if is_obstructed?(dest_x, dest_y)
    return false if dest_x < 0 || dest_x > 7 || dest_y < 0 || dest_y > 7
    return false if dest_piece && dest_piece.color == color
    dest_x == x_position || dest_y == y_position
  end
end
