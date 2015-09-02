class NullPiece
  attr_reader :color

  def empty?
    true
  end

  def initialize
    @color = :n
  end

  def dup(duped_board)
    NullPiece.new
  end

  def to_s
    "   "
  end
end
