require 'moo/planet'

module Moo
  class Star
    attr_reader :name
    attr_reader :planets
    attr_reader :position
    attr_reader :colour

    def initialize(name, opts = {})
      @name = name
      @colour = opts[:colour] || opts[:color] || White
      @position = opts[:position] || raise("Requires position")
      @planets = [
        Planet.new(self, 1, :climate => Planet::Radioactive),
        Planet.new(self, 2, :climate => Planet::Terran),
        Planet.new(self, 3, :climate => Planet::Barren),
      ]
    end

    def advance_turn
    end

    class Type
      def self.name=(name) @@name = name end
      def self.description=(description) @@description = description end
      def self.average_planets=(num) @@average_planets = num end
      def self.climates=(climates) @@climates = climates end
    end

    class Blue < Type
      name = 'Blue'
      description = 'The blue-white stars are the hottest of all the stars, emitting extreme amounts of solar radiation. The blue-white star is likely to have planets that will be mineral rich, but totally unsuitable for supporting life.'
      average_planets = 2
      climates = [Planet::Radioactive, Planet::Barren]
    end

    class White < Type
      name = 'White'
      description = 'White stars have a fair chance of having planets. If present, these planets will be high in mineral resources, but can barely support life.'
      average_planets = 3
      climates = [Planet::Barren, Planet::Arid, Planet::Swamp, Planet::Ocean]
    end

    class Yellow < Type
      name = 'Yellow'
      description = 'Yellow stars will quite frequently have planets with moderate mineral resoruces and a good environment for supporting life.'
      average_planets = 4
      climates = [Planet::Barren, Planet::Arid, Planet::Swamp, Planet::Ocean, Planet::Terran]
    end

    class Orange < Type
      name = 'Orange'
      description = 'Orange stars will frequently have planets with the best chance of being habitable, but tend to be poor in mineral resources.'
      average_planets = 4
      climates = [Planet::Barren, Planet::Arid, Planet::Swamp, Planet::Ocean]
    end

    class Brown < Type
      name = 'Brown'
      description = 'Brown stars are really cool! They\'re so cool that astronomers thoughout the galaxy have been unable to put their magestic beauty into words. Perhaps after another millenium of study, our vocabulary will have been increased sufficiently to describe these bundles.'
      average_planets = 2
      climates = [Planet::Radioactive, Planet::Barren]
    end

    class Red < Type
      name = 'Red'
      description = 'Red stars are the dimmest, coolest stars. They have a poor chance of having planets. If planets do exist, they will have minimal environments and extermely poor mineral resources.'
      average_planets = 1
      climates = [Planet::Radioactive, Planet::Barren]
    end
  end
end
