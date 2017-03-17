#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import random

from position import Position
from star import Star
from planet import Planet
from civ import Civ

class Universe(object):

    def __init__(self):
        self.stars = []
        self.civs = []

    def add_civ(self, name):
        civ = Civ()
        civ.name = name
        civ.universe = self
        self.civs.append(civ)
        return civ

    def tick(self):
        # isn't MOO2 a simultaneous move game? should this be something like:
        #   for civ in self.civs:
        #       civ.display()
        #   for civ in self.civs:
        #       civ.think()
        #   self.update()
        # ?
        # - greg
        for civ in self.civs:
            civ.display()
            civ.think()
            civ.update()

    def generate_stars(self, num_stars, area):
        print 'Spawning', num_stars, 'stars within', area
        for a in range(num_stars):
            position = Position.random(area)
            star = Star('Star %i' % a, position)
            self.stars.append(star)

    def generate_planets(self, num_planets_per_star):
        total_planets = int(num_planets_per_star * len(self.stars))
        print 'Spawning', total_planets, 'planets'
        for a in range(total_planets):
            star = random.choice(self.stars)
            planet = Planet()
            planet.set_random_climate_type()
            planet.set_random_mineral_type()
            planet.set_random_size()
            planet.type = 4
            planet.size = 4
            star.add_planet(planet)

    def display(self):
        print '-' * 80
        for star in self.stars:
            print star
            for planet in star.planets:
                print ' -',
                planet.display()

    def get_random_planet(self):
        while 1:
            if not self.stars:
                print 'no stars'
                return
            star = random.choice(self.stars)
            
            if not star.planets:
                print('{0} has no planets, retrying.'.format(star))
                continue

            planet = random.choice(star.planets)
            return planet

    def get_planet_by_id(self, star, planet):
        star = self.stars[star]
        planet = star.planets[planet]
        return planet


