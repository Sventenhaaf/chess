require_relative "piece"
require_relative "slidable"

class Castle < Piece
  include Slidable

  def possible_moves
    hor_valid_moves
  end

  def to_s
    color == :white ? " \u2656 " : " \u265C "
  end
end

class Bishop < Piece
  include Slidable

  def possible_moves
    dia_valid_moves
  end

  def to_s
    color == :white ? " \u2657 " : " \u265D "
  end
end

class Queen < Piece
  include Slidable


  def possible_moves
    dia_valid_moves + hor_valid_moves
  end

  def to_s
    color == :white ? " \u2655 " : " \u265B "
  end
end
