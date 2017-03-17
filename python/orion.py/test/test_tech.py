#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'source'))

from universe import Universe
from position import Position
import tech
import tech_tree

class TestTech(unittest.TestCase):

    def setup_scenario_simple(self):
        self.universe = Universe()
        self.universe.generate_stars(1, Position(100, 100))
        self.universe.generate_planets(2)
        self.civ = self.universe.add_civ(name='Land of Wanky Shit')
        self.planet = self.universe.get_random_planet()
        self.planet.owner = self.civ
        self.planet.population = 1.0

    def test_learn_tech(self):
        self.setup_scenario_simple()
        self.civ.learn_tech(tech_tree.colony_base)

if __name__ == '__main__':
    unittest.main()
