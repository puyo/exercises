#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Star(object):

    def __init__(self, name, position):
        self.owner = None
        self.name = name
        self.position = position
        self.neighbours = []
        self.planets = []

    def __str__(self):
        return '%s at %s' % (self.name, self.position)

    def add_planet(self, planet):
        self.planets.append(planet)
        planet.star = self
        planet.name = '%s-%i' % (self.name, len(self.planets) - 1)

