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
  let(:test_player) { instance_double(Player) }
  let(:test_board) { instance_double(Board) }
  describe '#new_turn' do
    before do
      test_game.players[0] = test_player
      test_game.players[1] = test_player
      allow(test_player).to receive(:play_move)
      allow(test_player).to receive(:piece)
      allow(test_game).to receive(:tie)
      allow(test_game).to receive(:end_game)
      allow(test_board).to receive(:check_win)
    end

    it 'Return tie game when turn count is 9' do
      allow(test_game).to receive(:turn_count).and_return(9)
      expect(test_game).to receive(:tie)
      test_game.new_turn
    end

    it 'Before board fills, send play_move to players' do
      expect(test_player).to receive(:play_move)
      test_game.new_turn
    end

    it 'End_game when board returns true on check win' do
      allow(test_board).to receive(:check_win).and_return(true)
      allow(test_game).to receive(:end_game)
      expect(test_game).to receive(:end_game)
      test_game.new_turn
    end
  end
end

describe Board do
  subject(:test_board) { described_class.new }
  describe '#invalid_move?' do
    it 'Returns false for move to empty space' do
      result = test_board.invalid_move?(0)
      expect(result).to be false
    end
    it 'Returns true for move to an occupied space' do
      test_board.board_state[0] = 'not empty'
      result = test_board.invalid_move?(0)
      expect(result).to be true
    end
  end
end
