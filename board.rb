require_relative "null_piece"
require_relative "pawn"
require_relative "sliding_pieces"
require_relative "stepping_pieces"

class MoveError < StandardError
end

class Board
  attr_accessor :grid

  def initialize(initial_setup = true)
    @sentinel = NullPiece.new
    @grid = Array.new(8) { Array.new(8, @sentinel) }
    populate if initial_setup
  end

  def empty?(pos)
    self[pos].empty?
  end

  def in_bound?(pos)
    pos.all? { |x| x.between?(0,7) }
  end

  def color(pos)
    self[pos].color
  end

  def populate
    #white
    @grid[0].each_index do |i|
      if i == 0 || i == 7
        @grid[0][i] = Castle.new(:white, self, [0,i])
      elsif i == 1 || i == 6
        @grid[0][i] = Knight.new(:white, self, [0,i])
      elsif i == 2 || i == 5
        @grid[0][i] = Bishop.new(:white, self, [0,i])
      elsif i == 3
        @grid[0][i] = Queen.new(:white, self, [0,i])
      elsif i == 4
        @grid[0][i] = King.new(:white, self, [0,i])
      end
    end

    8.times do |i|
      @grid[1][i] = Pawn.new(:white, self, [1,i])
      @grid[6][i] = Pawn.new(:black, self, [6,i])
    end

    # #black
    @grid[7].each_index do |i|
      if i == 0 || i == 7
        @grid[7][i] = Castle.new(:black, self, [7,i])
      elsif i == 1 || i == 6
        @grid[7][i] = Knight.new(:black, self, [7,i])
      elsif i == 2 || i == 5
        @grid[7][i] = Bishop.new(:black, self, [7,i])
      elsif i == 3
        @grid[7][i] = Queen.new(:black, self, [7,i])
      elsif i == 4
        @grid[7][i] = King.new(:black, self, [7,i])
      end
    end
  end

  def from_position(pos)
    @from_position = pos
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def []=(pos, mark)
    grid[pos[0]][pos[1]] = mark
  end

  def king_position(color)
    @grid.each_with_index do |row, row_i|
      row.each_with_index do |piece, col_i|

        if piece.is_a?(King) && piece.color == color
          return [row_i, col_i]
        end
      end
    end
  end

  def in_check?(color)
    king_position = king_position(color)

    @grid.each_index do |row|
      @grid[row].each_index do |col|
        return true if hits_king?([row,col], king_position, color)
      end
    end
    # .any?, .none?, .all?, .one?

    false
  end

  def pieces(color)
    @grid.flatten.select { |piece| piece.color == color }
  end

  def checkmate?(king_color)
    return false if in_check?(king_color) == false
    king_position = king_position(king_color)

    @grid.each_index do |row|
      @grid[row].each_index do |col|
        next if self[[row, col]].color != king_color
        return false unless self[[row, col]].valid_moves.empty?
      end
    end

    true
  end

  def hits_king?(position, king_position, king_color)
    if self[position].color == king_color || self.empty?(position)
      return false
    end

    self[position].possible_moves.include?(king_position)
  end

  def move_piece(start_point, end_point)
    piece = self[start_point]
    if start_point == end_point
      raise MoveError, "Make a new move (can't move piece to same position)"
    elsif !piece.possible_moves.include?(end_point)
      raise MoveError, "Can't move to this position!"
    elsif !piece.valid_moves.include?(end_point)
      raise MoveError, "This will put / keep you in check!"
    end

    move_piece!(start_point, end_point)
  end

  def move_piece!(start_point, end_point)
    self[start_point].position = end_point
    self[end_point], self[start_point] = self[start_point], @sentinel
  end

  def deep_dup
    new_board = Board.new(false)
    grid.each_with_index do |row, row_i|
      row.each_with_index do |piece, col_i|
        new_board[[row_i, col_i]] = piece.dup(new_board)
      end
    end

    new_board
  end
end
