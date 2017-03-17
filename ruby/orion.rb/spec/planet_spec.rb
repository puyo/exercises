require 'moo/galaxy'
require 'moo/vector2d'

include Moo

describe Planet, 'being created' do
  before do
    @star = Star.new('Test', :position => pos(0, 0))
  end

  it 'calculates maximum population' do
    [
      [Planet::Barren, [1, 3, 4, 5, 6]],
      [Planet::Toxic, [1, 3, 4, 5, 6]],
      [Planet::Radioactive, [1, 3, 4, 5, 6]],
      [Planet::Desert, [1, 3, 4, 5, 6]],
      [Planet::Tundra, [1, 3, 4, 5, 6]],
      [Planet::Ocean, [1, 3, 4, 5, 6]],
      [Planet::Swamp, [2, 4, 6, 8, 10]],
      [Planet::Arid, [3, 6, 9, 12, 15]],
      [Planet::Terran, [4, 8, 12, 16, 20]],
      [Planet::Gaia, [5, 10, 15, 20, 25]],
    ].each do |climate, maximums|
      maximums.each_with_index do |expected_max, i|
        size = Planet.sizes[i]
        new_planet(climate, size).max_population.should == expected_max
      end
    end
  end

  def new_planet(climate, size)
    Planet.new(@star, 1, :climate => climate, :size => size)
  end
end

