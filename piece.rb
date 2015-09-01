require_relative 'board.rb'
require_relative 'slidable'
require_relative 'steppable'
require_relative 'pawnable'


class Piece
  attr_reader :color, :position

  def initialize(color, board, position)
    @color = color
    @board = board
    @position = position
  end

  def present?
    true
  end

  def to_s
    " x "
  end


end

class NullPiece
  attr_reader :color

  def present?
    false
  end

  def initialize
    @color = :n
  end

  def to_s
    "   "
  end
end

class Pawn < Piece

  def initialize(color, board, position)
    super(color, board, position)
    @first_move = true
  end

  def possible_moves
    hor_valid_moves
  end



    def king_valid_moves
      moves(KING_DIRS)
    end

    def knight_valid_moves
      moves(KNIGHT_DIRS)
    end

    def moves(directions)
      positions = []
      directions.each do |dir|
        new_pos = [(position[0] + dir[0]), (position[1] + dir[1])]
        positions << new_pos if valid_move?(new_pos)
      end
      return positions
    end

    def valid_move?(pos)
      row = pos[0]
      col = pos[1]
      if row < 0 || row > 7 || col < 0 || col > 7
        return false
      elsif @board.grid[row][col].color == self.color
        return false
      end
      true
    end



  def to_s
    " p "
  end
end

class Castle < Piece
  include Slidable

  def possible_moves
    hor_valid_moves
  end

  def to_s
    " C "
  end
end

class Bishop < Piece
  include Slidable

  def possible_moves
    dia_valid_moves
  end

  def to_s
    " B "
  end
end

class Queen < Piece
  include Slidable


  def possible_moves
    dia_valid_moves + hor_valid_moves
  end

  def to_s
    " Q "
  end
end

class King < Piece
  include Steppable

  def possible_moves
    king_valid_moves
  end

  def to_s
    " K "
  end
end

class Knight < Piece
  include Steppable

  def possible_moves
    knight_valid_moves
  end

  def to_s
    " k "
  end
end
