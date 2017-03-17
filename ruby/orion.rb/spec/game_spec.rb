require 'moo/game'

describe Moo::Game, 'being created' do
  it 'supports valid parameters' do
    lambda do 
      opts = Moo::Game::Options.new :universe_size => :huge,
        :universe_age => :average,
        :start_tech_level => :average,
        :ai_difficulty => :impossible,
        :num_players => 8
      game = Moo::Game.new(opts)
      game.setup
      game.galaxy.should_not be_nil
    end.should_not raise_exception
  end
end

