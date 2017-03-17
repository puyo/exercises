require 'moo/galaxy'

module Moo
  class Game
    class Options
      attr_accessor :universe_size
      attr_accessor :universe_age
      attr_accessor :start_tech_level
      attr_accessor :ai_difficulty
      attr_accessor :num_players

      def initialize(vals)
        @vals = vals
      end

      class << self
        def huge_size() 10 end
        def average_age() 10 end
        def average_start_tech_level() 10 end
        def impossible_difficulty() 10 end
      end
    end

    def initialize(opts)
      @opts = opts
      @galaxy = Galaxy.new(opts)
    end

    def galaxy; @galaxy end

    def setup
      @galaxy.create_predefined
    end

    def output_state(io)
    end
  end
end
