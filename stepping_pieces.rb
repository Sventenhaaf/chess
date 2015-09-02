require_relative "piece"
require_relative "steppable"

class King < Piece
  include Steppable

  def possible_moves
    king_valid_moves
  end

  def to_s
    color == :white ? " \u2654 " : " \u265A "
  end
end

class Knight < Piece
  include Steppable

  def possible_moves
    knight_valid_moves
  end

  def to_s
    color == :white ? " \u2658 " : " \u265E "
  end
end
