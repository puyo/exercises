$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'moo/cli'

opts = Moo::Game::Options.new :universe_size => :huge,
  :universe_age => :average,
  :start_tech_level => :average,
  :ai_difficulty => :impossible,
  :num_players => 8

game = Moo::Game.new(opts)
cli = Moo::CLI.new(game)
cli.main_loop
