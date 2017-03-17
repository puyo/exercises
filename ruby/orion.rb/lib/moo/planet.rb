module Moo
  class Planet
    def initialize(star, number, opts = {})
      @star = star
      @number = number
      @colony = nil
      @size = opts[:size] || Small
      @climate = opts[:climate] || Terran
      @minerals = opts[:minerals] || MineralAbundant
      @gravity = opts[:gravity] || NormalGravity
    end

    def star; @star end
    def number; @number end
    def colony; @colony end
    def size; @size end
    def climate; @climate end
    def minerals; @minerals end
    def gravity; @gravity end

    def max_population
      @climate.max_population[@size]
    end

    class Size; end
    class Tiny < Size; end
    class Small < Size; end
    class Medium < Size; end
    class Large < Size; end
    class Huge < Size; end

    def self.sizes
      [Tiny, Small, Medium, Large, Huge] 
    end

    class Climate
      def self.food_per_worker=(prod) @food_per_worker = prod end
      def self.max_population() @max_population end
    end

    class Barren < Climate
      food_per_worker = 0
      @max_population = { Tiny => 1, Small => 3, Medium => 4, Large => 5, Huge => 6 }
    end

    class Toxic < Climate
      food_per_worker = 0
      @max_population = Barren.max_population
    end

    class Radioactive < Climate
      food_per_worker = 0
      @max_population = Barren.max_population
    end

    class Desert < Climate
      food_per_worker = 1
      @max_population = Barren.max_population
    end

    class Tundra < Climate
      food_per_worker = 1
      @max_population = Barren.max_population
    end

    class Ocean < Climate
      food_per_worker = 2
      @max_population = Barren.max_population
    end

    class Swamp < Climate
      food_per_worker = 2
      @max_population = { Tiny => 2, Small => 4, Medium => 6, Large => 8, Huge => 10 }
    end

    class Arid < Climate
      food_per_worker = 1
      @max_population = { Tiny => 3, Small => 6, Medium => 9, Large => 12, Huge => 15 }
    end

    class Terran < Climate
      food_per_worker = 2
      @max_population = { Tiny => 4, Small => 8, Medium => 12, Large => 16, Huge => 20 }
    end

    class Gaia < Climate
      food_per_worker = 3
      @max_population = { Tiny => 5, Small => 10, Medium => 15, Large => 20, Huge => 25 }
    end

    class MineralAbundance
      def self.name=(name) @@name = name end
      def self.industry_per_worker=(prod) @@industry_per_worker = prod end
    end

    class MineralUltraPoor < MineralAbundance
      name = 'Mineral Ultra Poor'
      industry_per_worker = 1
    end

    class MineralPoor < MineralAbundance
      name = 'Mineral Poor'
      industry_per_worker = 3
    end

    class MineralAbundant < MineralAbundance
      name = 'Mineral Abundant'
      industry_per_worker = 4
    end

    class MineralRich < MineralAbundance
      name = 'Mineral Rich'
      industry_per_worker = 6
    end

    class MineralUltraRich < MineralAbundance
      name = 'Mineral Ultra Rich'
      industry_per_worker = 8
    end

    class Gravity
      def self.name=(name) @@name = name end
      def self.worker_penalty=(percent) @@worker_penalty = percent end
    end

    class LowGravity < Gravity
      name = 'Low Gravity'
      worker_penalty = 25
    end

    class NormalGravity < Gravity
      name = 'Normal Gravity'
      worker_penalty = 0
    end
    
    class HighGravity < Gravity
      name = 'High Gravity'
      worker_penalty = 50
    end
  end
end

