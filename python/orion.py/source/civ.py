#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

from console import HistoryConsole
from ship_template import ShipTemplate
from finance import CivFinanceMixin
from command_points import CivCommandPointsMixin
from research import CivResearchMixin
from tech import CivTechMixin

class Civ(CivFinanceMixin, CivCommandPointsMixin, CivResearchMixin,
        CivTechMixin):
    
    def __init__(self):
        super(Civ, self).__init__()
        self.universe = None
        self.name = None
        self.planets = []
        self.ships = []
        self.ship_template_slots = [None]*5
        self.freighters = []
        self.heroes = []

    # Command line and helpers for it
    # -------------------------------------------------------------------------

    def help(self):
        print '''
Planet Management
 - "b [star] [planet] [building]" Add a building to the build queue
 - "w [star] [planet] [farmers] [builders] [scientists]" Set planet work load

Ship Design
 - "d [slot] [name]" Design a ship
 - "tl" List ship template slots

Ship Movement
 - "ms [ship] [star] [planet]" Tell ship to go to planet
 - "ls [ship] [population]" Load population from planet onto ship
 - "uls [ship] [population]" Unload population from ship to planet

Browse Planets
 - "lp" List all planets
'''

    def think(self):
        '''
        Allows the player to execute commands and change options in their civ.
        '''

        print '[ENTER] to end your turn, ? for halp'

        while 1:
            cmd = raw_input('> ')
            if not self.execute_cmd(cmd):
                return
        
    def execute_cmd(self, cmd):

        if not cmd:
            return False

        bits = cmd.split()

        if bits[0] == '?':
            self.help()

        if bits[0] == 'b':
            self.build(int(bits[1]), int(bits[2]), bits[3])

        if bits[0] == 'w':
            a = [ int(a) for a in bits[1:6] ]
            print a
            self.set_workers(*a)

        if bits[0] == 'd':
            slot = int(bits[1])

            sh = ShipTemplate()
            sh.name = bits[2]
            sh.configure()

            self.ship_template_slots[slot] = sh

        if bits[0] == 'tl':
            print self.ship_template_slots
        
        if bits[0] == 'lp':
            self.universe.display()

        if bits[0] == 'ms':
            self.move_ship(*[ int(a) for a in bits[1:] ])

        if bits[0] == 'ls':
            self.load_ship(*[ int(a) for a in bits[1:] ])

        if bits[0] == 'uls':
            self.unload_ship(int(bits[1]))

        if bits[0] == 'gak':
            from buildable.colonyship import ColonyShip
            ship = ColonyShip()
            ship.set_complete()
            self.ships.append(ship)
            ship.planet = self.universe.get_planet_by_id(0, 0)
            print ship.planet

        return True

    def load_ship(self, ship, pop):
        ship = self.get_ship_by_id(ship)

        if not ship.planet:
            print 'Ship needs to be docked'
            return

        if ship.planet.population < pop:
            print 'You dont have enough population on the planet'
            return

        if ship.available_population_cargo < pop:
            print 'You dont have enough cargo room on the ship'
            return

        ship.population_cargo += pop
        ship.planet.population -= pop
        print 'moved {pop} pop from {ship.planet} to {ship}'.format(**locals())

    def unload_ship(self, ship):
        ship = self.get_ship_by_id(ship)

        if not ship.planet:
            print 'Ship needs to be docked'
            return

        if ship.planet.owner not in (None, self):
            print 'This planet does not belong to you.'
            return

        if not ship.planet.owner:
            ship.planet.owner = self

        pop = ship.population_cargo
        
        ship.planet.population += pop
        ship.population_cargo = 0

        print 'moved {pop} off {ship} to {ship.planet}'.format(**locals())

    def move_ship(self, ship, star, planet):
        ship = self.get_ship_by_id(ship)
        planet = self.universe.get_planet_by_id(star, planet)
        ship.dest = planet

#        planet = self.universe.get_planet_by_id(star, planet)
#        ship.dest = planet
#        ship.position = ship.planet.position

    def get_ship_by_id(self, ship_id):
        return self.ships[ship_id]

    def build(self, star, planet, building):
        planet = self.universe.get_planet_by_id(star, planet)
        if not planet:
            print('Could not find planet')
            return
        planet.add_to_build_queue(building)

    def set_workers(self, star, planet, farmers, builders, scientists):
        planet = self.universe.get_planet_by_id(star, planet)
        if not planet:
            print('Could not find planet')
            return
        planet.set_workers(farmers, builders, scientists)

    # Update
    # -------------------------------------------------------------------------

    def update(self):
        '''
        Does updates on population, build queues, etc
        '''
        print('-' * 80)
        print('UPDATING')
        print('-' * 80)
        self.update_credits()
        self.update_food_distribution()
        self.update_ships()

        for planet in self.planets:
            print('Updating {0}'.format(planet))
            planet.update()
       
    # Ship Updates
    # -------------------------------------------------------------------------

    def update_ships(self):
        for ship in self.ships:
            ship.update()

    # Food Distribution
    # -------------------------------------------------------------------------

    @property
    def freighter_points(self):
        return sum([a.freighter_points for a in self.freighters])

    def add_freighter(self, freighter):
        self.freighters.append(freighter)

    def _get_total_food_direction(self, surplus):
        '''
        A Helper function to either caluclate total surplus or lacking food.
        Please note these are the pre-freight values.
        '''
        a = 0
        for planet in self.planets:
            food = planet.pre_food_surplus
            if (food > 0 and surplus) or (food < 0 and not surplus):
                a += food
        if not surplus:
            a = -a
        return a

    @property
    def total_food_surplus(self):
        return self._get_total_food_direction(True)

    @property
    def total_food_lacking(self):
        return self._get_total_food_direction(False)

    def update_food_distribution(self):

        surplus = self.total_food_surplus
        lacking = self.total_food_lacking

        required_freight = min(surplus, lacking)
        print ' - Food: Surplus:', surplus,
        print 'Lacking:', lacking

        freighter_points_left = required_freight
        if freighter_points_left > self.freighter_points:
            freighter_points_left = self.freighter_points

        print ' - Freighters: Used:', freighter_points_left,
        print 'Required:', required_freight

        for planet in self.planets:
            
            planet.freight_supplies = 0

            if freighter_points_left <= 0:
                continue
            
            food = planet.pre_food_surplus
            if food >= 0:
                continue
            food = -food
            if food > freighter_points_left:
                food = freighter_points_left
            print ' - Transporting', food, 'food to', planet
            freighter_points_left -= food
            planet.freight_supplies += food

    # Display
    # -------------------------------------------------------------------------

    def display(self):
        print('-' * 80)
        print(self.summary())
        print(self.display_ships())
        print('-' * 80)
        for planet in self.planets:
            planet.display()
        print('-' * 80)

    def summary(self):

        # laziness ftw. is there a better way of doing this?
        d = dict([ (a, getattr(self, a)) for a in dir(self) ])
        return '{name} {credits}BC Freight:{freighter_points}' \
            .format(**d)

    def display_ships(self):
            print('- Ships: ' + ', '.join([ '{0}:{1}'.format(a, str(b)) for a, b in
                enumerate(self.ships)]))

    def __str__(self):
        return '[The {0} Empire]'.format(self.name)
   
    # Observer stuff
    # -------------------------------------------------------------------------

    # TODO: maybe define notify on all objects so that when other objects fuck
    # with them, stuff can happen here
    def notify(self, caller, method):
        pass


