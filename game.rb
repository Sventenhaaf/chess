require_relative "board"
require_relative "player"

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @player1 = Player.new(@board, :w)
    @player2 = Player.new(@board, :b)
    @current_player = @player1
  end

  def run
    puts "WASD or arrow keys to move the cursor, enter or space to confirm."
    until board.checkmate?(:w) || board.checkmate?(:b)
      play_turn
      switch_players!
    end
    switch_players!
    puts "Checkmate! #{@current_player.color} wins!"
  end

  def play_turn
    begin
      get_move
    rescue MoveError
      puts "Invalid move! Try again"
      sleep(2)
      retry
    end
  end

  def get_move
    puts "Where would you like to move?"
    from_pos = @current_player.move
    to_pos = @current_player.move
    if @board[from_pos].color != @current_player.color
      raise MoveError, "Only allowed to play your own color"
    end
    board.move_piece(from_pos, to_pos)
  end

  def switch_players!
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end




end




if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
