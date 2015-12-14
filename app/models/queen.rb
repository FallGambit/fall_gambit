class Queen < Piece
# the coolest ass-kicking bitch in the whole game of course

  def valid_move?(dest_x, dest_y)
    return false if dest_x < 0 || dest_x > 7 || dest_y < 0 || dest_y > 7
    delta_x = (dest_x - x_position)
    delta_y = (dest_y - y_position)
    return false if delta_x != 0 && delta_y != 0 && delta_x.abs != delta_y.abs
    return false if is_obstructed?(dest_x, dest_y)
    dest_piece = game.pieces
                 .where("x_position = ? AND y_position = ?", dest_x, dest_y)
                 .take
    return false if dest_piece && dest_piece.color == color
    true
  end
end
