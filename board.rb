require_relative "piece"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.new } }
    populate
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

    #black
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
  end

  # def full?
  #   @grid.all? do |row|
  #     row.all? { |piece| piece.present? }
  #   end
  # end

  def mark(pos)
    x, y = pos
    @grid[x][y] = Piece.new
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end
end
