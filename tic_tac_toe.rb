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
  def initialize
    player_x = Player.new('X')
    player_o = Player.new('O')
  end
end

class Board
end