# frozen_string_literal: true

require './tic_tac_toe'

describe Player do
  subject(:player_x) { described_class.new('X') }
  let(:test_board) { instance_double(Board) }
  describe '#play_move' do
    context 'playing a move' do
      before do
        allow(player_x).to receive(:puts)
      end
      it 'play a valid move' do
        allow(player_x).to receive(:gets).and_return("a1\n")
        allow(test_board).to receive(:invalid_move?).and_return(false)
        expect(test_board).to receive(:update_board).once
        player_x.play_move(test_board)
      end

      it 'play an invalid move and then a valid move' do
        allow(player_x).to receive(:gets).and_return("a1\n")
        allow(test_board).to receive(:invalid_move?).and_return(true, false)
        expect(test_board).to receive(:display_board).once
        expect(test_board).to receive(:update_board).once
        player_x.play_move(test_board)
      end
    end
  end

  describe '#translate' do
    it 'returns correct index on valid input' do
      input = 'a1'
      result = player_x.translate(input)
      expect(result).to eq(0)
    end
    it 'returns nil on invalid input' do
      input = 'hello'
      result = player_x.translate(input)
      expect(result).to be_nil
    end
  end
end

describe Game do
  subject(:test_game) { described_class.new }
  let(:player) { instance_double(Player) }
  describe '#new_turn' do
    it 'turn count is less than 10' do
      @players = []
      @players << player
      @players << player
      @turn_count = 4
      expect(player).to receive(:play_move)
      test_game.new_turn
    end
  end
end