require 'moo/star'
require 'moo/vector2d'

module Moo
  class Galaxy
    def initialize(opts = {})
      @width = 0.0
      @height = 0.0
      @stars = []
      @races = []
    end

    def create_predefined
      # static for now
      @width = 20.0
      @height = 20.0
      @stars = [
        sol = Star.new('Sol', :position => pos(9, 9)),
        tai = Star.new('Tai', :position => pos(11, 12)),
      ]
      @races = [
      ]
    end

    def advance_turn
      @races.each {|race| race.advance_turn } # grow colonies, etc.
      @stars.each {|star| star.advance_turn } # rotate planets
    end
  end
end

