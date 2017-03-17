#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Building(object):
    name = None
    cost = 0
    maintenance = 0

    def __init__(self):
        super(Building, self).__init__()

    def on_build(planet):
        raise NotImplementedError

    @property
    def description(self):
        return self.__class__.__doc__

    def can_build(self, planet):
        return True

    def can_build_always(self, planet):
        return True

    def can_build_one_per_planet(self, planet):
        return not self in planet.buildings
