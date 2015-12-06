class Knight < Piece
  def is_obstructed?(dest_x, dest_y)
    false
  end

  def valid_move?(dest_x, dest_y)
    delta_x = dest_x - x_position
    delta_y = dest_y - y_position
    dest_piece = game.pieces.where("x_position = ? AND y_position = ?", dest_x, dest_y)

    return false if dest_x < 0 || dest_x > 7 || dest_y < 0 || dest_y > 7
    return false if dest_piece.color == self.color
    return true if delta_x.abs == 2 && delta_y.abs == 1
    return true if delta_x.abs == 1 && delta_y.abs == 2
  end
end
