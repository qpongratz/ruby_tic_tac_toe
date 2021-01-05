class Player
  
  def initialize(piece)
    @piece = piece
    self.get_player_name
  end

  def get_player_name
    puts "What would the player of #{@piece}'s like to be called?"
    @player_name = gets.chomp
  end

  def get_move
    puts "#{player_name}'s turn. On what space would you like a #{piece}?"
    gets.chomp #eventually pass to a check with board once I have that setup
end

class Game
  attr_accessor(:board)
  
  def initialize
    @turn_count = 0
    self.board = Board.new
    @players = [(Player.new('X')), (Player.new('O'))]
    @players.shuffle!
    self.new_turn
  end

  def new_turn
    @turn_count += 1
    @players[@turn_count % 2].get_move
  end
end

class Board
  def initialize
    @board_state = Array.new(9)
  end

  def display_board 
    @display = @board_state.map {|spot| spot.nil? ? spot = ' ' : spot}
    puts "#{@display[0]}│#{@display[1]}│#{@display[2]}"
    puts "─┼─┼─"
    puts "#{@display[3]}│#{@display[4]}│#{@display[5]}"
    puts "─┼─┼─"
    puts "#{@display[6]}│#{@display[7]}│#{@display[8]}"    
  end
end

test_board = Board.new
test_board.display_board
end