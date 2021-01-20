# frozen_string_literal: true

require_relative '../tic_tac_toe.rb'

describe Player do
  subject(:playerx) { described_class.new('X') }
  let(:test_board) { instance_double(Board) }
  

  describe '#play_move' do
    context 'playing a move' do
      
      before do
        allow(test_board).to receive(:display_board)
        allow(test_board).to receive(:invalid_move?)
        # allow(playerx).to receive(:set_player_name)
        allow(playerx).to receive(:puts)
        allow(playerx).to receive(:input).and_return('hello')
      end
      it 'sends an input to translate' do
        allow(playerx).to receive(:translate)
        expect(playerx).to receive(:translate)
        playerx.play_move(test_board)
      end
    end
  end
end

