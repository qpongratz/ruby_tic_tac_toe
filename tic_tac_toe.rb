class Player
  def initialize(piece)
    @piece = piece
    self.get_player_name
  end
  def get_player_name
    puts "What would the player of #{@piece}'s like to be called?"
    @player_name = gets.chomp
  end
end

class Game
  attr_accessor(:board)
  
  def initialize
    @turn_count = 0
    self.board = Board.new
    @players = [(Player.new('X')), (Player.new('O'))]
    @players.shuffle!
  end

  def new_turn
    @turn_count += 1
    
  end
end

class Board
  def initialize
    @board_state = Array.new(9)
  end
end