require_relative "piece"

class MoveError < StandardError
end

class Board
  attr_accessor :grid

  def initialize(initial_setup = true)
    @grid = Array.new(8) { Array.new(8) { NullPiece.new } }
    populate if initial_setup
  end

  def empty?(pos)
    return true if self[pos].is_a?(NullPiece)
    false
  end

  def in_bound?(pos)
    return false if pos[0] < 0 || pos[0] > 7 || pos[1] < 0 || pos[1] > 7
    true
  end

  def color(pos)
    self[pos].color
  end

  def populate
    #white
    @grid[0].each_index do |i|
      if i == 0 || i == 7
        @grid[0][i] = Castle.new(:w, self, [0,i])
      elsif i == 1 || i == 6
        @grid[0][i] = Knight.new(:w, self, [0,i])
      elsif i == 2 || i == 5
        @grid[0][i] = Bishop.new(:w, self, [0,i])
      elsif i == 3
        @grid[0][i] = Queen.new(:w, self, [0,i])
      elsif i == 4
        @grid[0][i] = King.new(:w, self, [0,i])
      end
    end

    8.times do |i|
      @grid[1][i] = Pawn.new(:w, self, [1,i])
      @grid[6][i] = Pawn.new(:b, self, [6,i])
    end
    
    # #black
    @grid[7].each_index do |i|
      if i == 0 || i == 7
        @grid[7][i] = Castle.new(:b, self, [7,i])
      elsif i == 1 || i == 6
        @grid[7][i] = Knight.new(:b, self, [7,i])
      elsif i == 2 || i == 5
        @grid[7][i] = Bishop.new(:b, self, [7,i])
      elsif i == 3
        @grid[7][i] = Queen.new(:b, self, [7,i])
      elsif i == 4
        @grid[7][i] = King.new(:b, self, [7,i])
      end
    end

############### TESTING!
    #
    # self[[0,0]] = King.new(:w, self, [0,0])
    # self[[0,2]] = Castle.new(:b, self, [0,2])
    # self[[1,2]] = Castle.new(:b, self, [1,2])

  end

  # def full?
  #   @grid.all? do |row|
  #     row.all? { |piece| piece.present? }
  #   end
  # end

  # def mark(pos)
  #   x, y = pos
  #   @grid[x][y] = Piece.new
  # end

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
      row.each_index do |col_i|
        return [row_i, col_i] if self[[row_i, col_i]].is_a?(King) && self[[row_i, col_i]].color == color
      end
    end
    raise "No king of this color on board"
  end

  def in_check?(color)
    # set king position
    king_position = king_position(color)

    @grid.each_index do |row|
      @grid[row].each_index do |col|
        return true if hits_king?([row,col], king_position, color)
      end
    end
    false
    # check all possible moves of opponent color
  end

  def checkmate?(kingcolor)

    return false if in_check?(kingcolor) == false
    king_position = king_position(kingcolor)

    @grid.each_index do |row|
      @grid[row].each_index do |col|
        next if self[[row, col]].color != kingcolor
        return false unless self[[row, col]].valid_moves.empty?
      end
    end

    true
  end

  def hits_king?(position, king_position, king_color)
    return false if self[position].color == king_color
    return false if self.empty?(position)
    self[position].possible_moves.include?(king_position)
  end

  def move_piece(start_point, end_point)
    piece = self[start_point]
    if start_point == end_point
      raise MoveError, "Can't move to same position"
    elsif !piece.valid_moves.include?(end_point)
      raise MoveError, "Invalid move!"
    end
    move_piece!(start_point, end_point)
  end

  def move_piece!(start_point, end_point)
    self[start_point].position = end_point
    self[end_point], self[start_point] = self[start_point], NullPiece.new
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
