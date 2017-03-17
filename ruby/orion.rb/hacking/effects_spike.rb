# Problem: How do you cope with the numerous sources of modifiers and special
# abilities in MOO2?

module Moo
  class Race
    def initialize(opts = {})
      @adjective, @leader_name = opts[:adjective], opts[:leader_name]
      @color = opts[:color]
      @picks = []
      @technologies_learned = []
      @effects = false
    end

    def effects; @effects end
  end

  class RacialPick
    def self.name(name) @@name = name end
    def self.description(desc) @@desc = desc end
    def self.cost(cost) @@cost = cost end
    def self.excludes(&block) @@excludes = block end

    def name; @@name end
    def description; @@description end
    def cost; @@cost end
    def excludes; @@block.call end

    def select(race)
      on_select(race)
    end

    def unselect(race)
      on_unselect(race)
    end

    def inspect
      "<RacialPick #{name} [#{cost}]>"
    end

    def self.inherited(subclass)
      Game.racial_picks.push subclass
    end
  end

  class Technology
    def self.name(name) @@name = name end
    def self.description(desc) @@desc = desc end
    def self.rp_cost(cost) @@rp_cost = cost end
    def self.tech_category(id); @@tech_category = id end
    def self.tech_level(level); @@tech_level = level end

    def name; @@name end
    def description; @@description end
    def rp_cost; @@rp_cost end
    def tech_category; @@tech_category end
    def tech_level; @@tech_level end

    def self.inherited(subclass)
      Game.technologies.push subclass
    end
  end

  class Effects
    def initialize
      @ship_evade_modifiers = []
      @tech_grants_random_from_tech_level = false
    end

    def ship_evade_modifiers; @ship_evade_modifiers end
    def technologies_learned; @technologies_learned end

    def ship_evade_modifier_total
      @ship_evade_modifiers.map{|m| m.ship_evade_modifier }.sum
    end

    def tech_grants_random_from_tech_level?
      @tech_grants_random_from_tech_level
    end

    def tech_grants_random_from_tech_level=(value)
      @tech_grants_random_from_tech_level = (value == true)
    end
  end

  class Leader
    def initialize(name, abilities, opts = {})
      @name = name
      @abilities = abilities
      @hire_cost = opts[:hire_cost] || 0
      @maintenance_cost = opts[:maintenance_cost] || 0
      @level = (opts[:level] || 1).to_i
    end

    def hire(race)
      @race = race
      setup_abilities(race.effects, true)
    end

    def fire(race)
      @race = nil
      teardown_abilities(race.effects, true)
    end

    def setup_abilities(effects, global)
      @abilities.each{|a| a.on_setup(effects) if a.global? == global }
    end

    def teardown_abilities(effects, global)
      @abilities.each{|a| a.on_teardown(race.effects) if a.global? == global }
    end
  end

  class FleetLeader < Leader
    def fleet; @fleet end

    def assign(fleet)
      @fleet = fleet
      setup_abilities(fleet.effects, false)
    end

    def unassign(fleet)
      @fleet = nil
      teardown_abilities(fleet.effects, false)
    end
  end

  class ColonyLeader < Leader
    def colony; @colony end

    def assign(colony)
      @colony = colony
      setup_abilities(colony.effects, false)
    end

    def unassign(colony)
      @colony = nil
      teardown_abilities(colony.effects, false)
    end
  end

  class LeaderAbility
    def self.name(name) @@name = name end
    def self.description(desc) @@desc = desc end
    def self.cost_per_level(cost) @@cost_per_level = cost end

    def initialize(opts = {})
      @leader = opts[:leader] or raise("Leader required")
      @global = (opts[:global] == true)
    end

    def leader; @leader end

    # Does this ability apply to a specific colony or fleet, or the entire
    # race?
    def global?; @global end
  end

  class Game
    @@racial_picks = []
    @@technologies = []
    @@colony_leader_abilities = []
    @@fleet_leader_abilities = []

    class << self
      def racial_picks; @@racial_picks end
      def technologies; @@technologies end
      def colony_leader_abilities; @@colony_leader_abilities end
      def fleet_leader_abilities; @@fleet_leader_abilities end
    end
  end
end

# ----------------------------------------------------------------
# Tests

require 'rubygems' rescue nil
require 'spec'

describe Moo::RacialPick do
  it 'should add new definitions to the game class' do
    module MyGame
      class Creative < Moo::RacialPick
        name 'Creative'
        description 'Creative races are...'
        cost 8
        excludes { Uncreative }

        def on_select(race)
          race.effects.tech_grants_random_from_tech_level = true
        end

        def on_deselect(race)
          race.effects.tech_grants_random_from_tech_level = false
        end
      end
    end
    Moo::Game.racial_picks.should include(MyGame::Creative)
  end
end

# ----------------------------------------------------------------
# Game specific data

module MyGame
  class ShipDefenseNeg20 < Moo::RacialPick
    name 'Ship Defense -20'
    description 'Ship defense bonuses decrease the chance...'
    excludes { [ShipDefensePos25, ShipDefensePos50] }
    cost -2

    def on_select(race)
      race.effects.ship_evade_modifiers.push(self)
    end

    def on_deselect(race)
      race.effects.ship_evade_modifiers.delete(self)
    end

    def ship_evade_modifier
      -20
    end
  end

  class ReflectiveNanites < Moo::Technology
    name 'Reflective Nanites'
    description 'Covers all ships produced with nanites that makes them harder to hit'
    rp_cost 1500
    tech_category 'Construction'
    tech_level 4

    def on_learn(race)
      race.effects.ship_evade_modifiers.push(self)
    end

    def on_forget(race)
      race.effects.ship_evade_modifiers.delete(self)
    end

    def ship_evade_modifier
      20
    end
  end

  class IndustriousAbility < Moo::LeaderAbility
    name 'Industrial Leader'
    description 'This leader increases production on affected colonies'
    cost_per_level 2

    def on_setup(ability, effects)
      effects.colonist_production_percent_modifiers.push(ability)
    end

    def on_teardown(ability, effects)
      effects.colonist_production_percent_modifiers.delete(ability)
    end

    def colonist_production_percent_modifier(ability)
      ability.leader.level * 0.2
    end
  end
end
