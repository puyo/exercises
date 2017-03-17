#!/usr/bin/env python
# -*- coding: utf-8 -*-

from universe import Universe
from position import Position

class Main(object):

    def __init__(self):
        self.pewp()

    def pewp(self):
        # XXX: Dave's test universe :)
        self.universe = Universe()
        self.universe.generate_stars(10, Position(100, 100))
        self.universe.generate_planets(1.5)
        dave_civ = self.universe.add_civ('dave')

        planet = self.universe.get_random_planet()
        planet.owner = dave_civ
        planet.population = 1
        planet.set_auto_workers()
        
        planet = self.universe.get_random_planet()
        planet.owner = dave_civ
        planet.population = 0.1
        planet.set_auto_workers()

    def loop(self):
        while 1:
#            self.universe.display()
            self.universe.tick()
