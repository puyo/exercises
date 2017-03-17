require 'readline'
require 'moo/game'

module Moo
  class CLI
    def initialize(game)
      @game = game
    end

    def main_loop
      stty_save = `stty -g`.chomp
      trap('INT') { system('stty', stty_save); exit }
      loop do 
        @game.output_state($stdout)
        line = Readline.readline('> ', true)
        break if line.nil?
        process_line(line)
      end
    end

    def process_line(line)
      case line
      when 'quit', 'q'
        exit
      when 'turn', 't'
      end
    end
  end
end
