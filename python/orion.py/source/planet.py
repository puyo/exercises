#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
import math

from civ import Civ
from planet_queue import PlanetQueue

from buildable.factory import BuildingFactory
from buildable.buildablemixin import BuildableMixin
from buildable.shipmixin import ShipMixin
from buildable.transportmixin import TransportMixin
from buildable.freightermixin import FreighterMixin
from finance import PlanetFinanceMixin
from research import PlanetResearchMixin

climate_types = [
        'toxic',
        'radiated',
        'barren',
        'desert',
        'tundra',
        'arid',
        'swamp',
        'ocean',
        'terran',
        'gaia',
        ]

mineral_types = [
        'ultra poor',
        'poor',
        'abundant',
        'rich',
        'ultra rich',
        ]

sizes = [
        'tiny',
        'small',
        'average',
        'large',
        'huge',
        ]

hammers_per_builder = {
        'ultra poor': 1,
        'poor': 2,
        'abundant': 3,
        'rich': 5,
        'ultra rich': 8,
        }

food_per_farmer = {
        'toxic': 0,
        'radiated': 0,
        'barren': 0,
        'desert': 1,
        'tundra': 1,
        'arid': 1,
        'swamp': 2,
        'ocean': 2,
        'terran': 2,
        'gaia': 3,
        }

class Planet(PlanetFinanceMixin, PlanetResearchMixin):

    __slots__ = 'star name owner size type buildings build_queue population ' \
        '_farmers scientists builders freight_supplies'.split(' ')

    def __init__(self):
        super(Planet, self).__init__()
        self.star = None
        self.name = None
        self.owner = None
        self.size = 0
        self.climate_type = 0
        self.mineral_type = 0
        self.buildings = []
        self.build_queue = PlanetQueue()
        self.population = 0.0
        self._farmers = 0
        self.scientists = 0
        self.builders = 0
        self.freight_supplies = 0

    def __repr__(self):
        return 'Planet {self.name} ({self.owner}, {self.size_name},' \
            ' {self.climate_type_name},' \
            ' {self.mineral_type_name})'.format(**locals())

    def __setattr__(self, attr, obj):
        # When owner changes, we should inform the Player that they do in fact
        # now own the planet.
        # TODO: figure out a non-shitty way of delegating this to obj
        # TODO: this could be a property instead of in a setattr
        if attr == 'owner' and isinstance(obj, Civ): obj.planets.append(self)
        super.__setattr__(self, attr, obj)

    # Main methods
    # -------------------------------------------------------------------------

    def update(self):
        self.update_new_population()
        self.update_build_queue()

    def display(self):

        if not self.owner:
            print(self)
            return

        print(
            '{self} POP:{self.population:02.1f}/{self.max_population:02.1f}'
            ' F:{self.farmers} ({self.pre_food_surplus:+0.1f}/'
            '{self.post_food_surplus:+0.1f})'
            ' B:{self.builders}'
            ' S:{self.scientists}'
            ' T:{self.potential_workers}'
            ' FOOD HELP:{self.freight_supplies}'
        .format(**locals()))

        if self.built_buildings:
            print('- ' + ', '.join([ str(a) for a in self.built_buildings]))
        
    # Map generation
    # -------------------------------------------------------------------------

    def set_random_climate_type(self, bias=None):
        if bias is None:
            bias = len(climate_types) / 2
        self.climate_type = int(random.triangular(0, len(climate_types), bias))

    def set_random_mineral_type(self, bias=None):
        if bias is None:
            bias = len(climate_types) / 2
        self.mineral_type = int(random.triangular(0, len(mineral_types), bias))

    def set_random_size(self, bias=None):
        if bias is None:
            bias = len(sizes) / 2
        self.size = int(random.triangular(0, len(sizes), bias))

    # Planet composition
    # -------------------------------------------------------------------------

    @property
    def size_name(self):
        return sizes[self.size]

    @property
    def climate_type_name(self):
        return climate_types[self.climate_type]

    @property
    def mineral_type_name(self):
        return mineral_types[self.mineral_type]

    # Worker helpers
    # -------------------------------------------------------------------------
   
    @property
    def farmers(self):
        return self._farmers

    @farmers.setter
    def farmers(self, v):
        assert(v == int(v))
        self._farmers = v

    @property
    def potential_workers(self):
        return int(math.ceil(self.population))

    @property
    def current_workers(self):
        return self.farmers + self.builders + self.scientists

    def set_workers(self, farmers, builders, scientists):
        self.farmers = farmers
        self.builders = builders
        self.scientists = scientists

    # Builders logic
    # -------------------------------------------------------------------------

    @property
    def hammers_produced(self):
        return self.builders \
                * hammers_per_builder[mineral_types[self.mineral_type]]

    @property
    def hammers_per_builder(self):
        [
            'radioactive',
            'barren',
            'mediocre',
            'rich',
            'abundant',
        ]

    @property
    def hammers_total(self):
        return self.hammers - self.hammers_lost_to_industry_tax()

    # Worker logic
    # -------------------------------------------------------------------------

    def set_auto_workers(self):
        '''
        Sets enough farmers for the population and 50/50 for scientists and
        builders.

        >>> p = Planet()
        >>> p.population = 5
        >>> p.type = 3

        >>> p.set_auto_workers()
        >>> p.farmers
        3
        >>> p.builders
        1

        '''
        workers_left = self.potential_workers

        # oh noes, not enough workers to make food
        if self.farmers_required < workers_left:
            self.farmers = workers_left
            self.scientists = 0
            self.builders = 0
            return

        self.farmers = self.farmers_required
        workers_left -= self.farmers

        self.builders = workers_left / 2
        workers_left -= self.builders

        self.scientists = workers_left

    def set_auto_new_workers(self):
        '''Any 'spare' workers will be assigned jobs'''

        if self.potential_workers <= self.current_workers:
            return
        
        new_farmers = new_scientists = new_builders = 0

        workers_left = self.potential_workers - self.current_workers

        if self.post_food_surplus <= 1:
            new_farmers = int(math.ceil(-self.post_food_surplus + 1))
            if new_farmers > workers_left:
                new_farmers = workers_left
            workers_left -= new_farmers

        # XXX: Randomly assign workers to either builders or scientists
        for a in range(workers_left):
            if random.randint(0, 1):
                new_scientists += 1
            else:
                new_builders += 1
        
        self.farmers += new_farmers
        self.scientists += new_scientists
        self.builders += new_builders

        print(' - {new_farmers} new farmers, {new_scientists} new scientists, '
            '{new_builders} new builders'.format(**locals()))


    # Food logic
    # -------------------------------------------------------------------------

    @property
    def pre_food_produced(self):
        '''pre supply'''
        return self.farmers * self.food_produced_per_farmer

    @property
    def post_food_produced(self):
        '''post supply'''
        return self.pre_food_produced + self.freight_supplies

    @property    
    def post_food_surplus_perc(self):
        if not self.population:
            return 0
        return self.post_food_produced / self.population

    @property
    def pre_food_surplus(self):
        '''pre supply'''
        return int(math.ceil(self.pre_food_produced - self.food_required))

    @property
    def post_food_surplus(self):
        '''pre supply'''
        return int(math.ceil(self.post_food_produced - self.food_required))

    @property
    def food_produced_per_farmer(self):
        amount = self.type - 1
        if amount < 0:
            amount = 0
        return amount
    
    @property
    def food_required(self):
        return int(math.ceil(self.population))

    @property
    def farmers_required(self):
        fppf = self.food_produced_per_farmer
        if not fppf:
            return 0
        return int(math.ceil(self.food_required / fppf))
    
    # Population logic
    # -------------------------------------------------------------------------
    
    @property
    def population_growth_perc(self):
        growth = 1.05

        for building in self.built_buildings:
            growth *= building.population_growth_perc

        return growth

    @property
    def population_starvation_perc(self):
        return 0.9

    @property
    def is_starving(self):
        return self.post_food_surplus < 0

    @property
    def max_population(self):
        return 2 * (1 + self.size)

    def update_new_population(self):

        if not self.population:
            print(' - {0} has no population'.format(self))
            return

        if not self.is_starving:
            self.population *= self.population_growth_perc
        else:
            print(' - Population is starving!')
            self.population *= self.population_starvation_perc
        
        if not self.population:
            print(' - {0} has lost all of its population! :('.format(self))
            return

        if self.population > self.max_population:
            self.population = self.max_population

        self.set_auto_new_workers()

    # Building
    # -------------------------------------------------------------------------

    def update_build_queue(self):

        if not self.build_queue.get():
            print(' - Nothing in build queue')
            return

        building = self.build_queue.get()

        print(' - Currently building {0}'.format(building))

        building.progress(self.hammers_total)

        # XXX: This code might be better somewhere else
        if building.is_complete:
            self.build_queue.pop()

            # We don't want ships to be a building on this planet, so
            # remove them from the building list for this planet and give it to
            # the civlisation that owns us.

            if isinstance(building, ShipMixin):
                ship = building
                self.buildings.remove(ship)
                self.owner.ships.append(ship)

            if isinstance(building, FreighterMixin):
                self.buildings.remove(building)
                self.owner.add_freighter(building)


    def add_to_build_queue(self, building_name):

        building = BuildingFactory.get(building_name, self.owner)

        if building.unique_per_planet and self.has_building(building):
            print ' - Building already exists'
            return

        building.planet = self

        self.build_queue.add(building)
        self.buildings.append(building) 

    def has_building(self, building):
        
        for other in self.buildings:
            if type(building) == type(other):
                return True

        return False

    @property
    def built_buildings(self):
        return [ a for a in self.buildings if a.is_complete ]

    # Position
    # -------------------------------------------------------------------------

    @property
    def position(self):
        return self.star.position

if __name__ == "__main__":
    import doctest
    doctest.testmod()

