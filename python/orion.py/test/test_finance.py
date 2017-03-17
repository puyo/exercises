#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'source'))

from universe import Universe
from position import Position
import planet

class TestFinance(unittest.TestCase):

    def setup_scenario_simple(self):
        self.universe = Universe()
        self.universe.generate_stars(1, Position(100, 100))
        self.universe.generate_planets(2)
        self.civ = self.universe.add_civ(name='Land of Wanky Shit')
        self.planet = self.universe.get_random_planet()
        self.planet.owner = self.civ
        self.planet.population = 1.0

    def test_1_worker_1_credit(self):
        self.setup_scenario_simple()
        old_credits = self.civ.credits
        self.civ.update()
        self.assertEqual(old_credits + 1, self.civ.credits) # 1 worker

    def test_hammer_tax(self):
        self.setup_scenario_simple()
        self.planet.population = 2
        self.planet.builders = 2
        # NB: abundant means 3 hammers per worker
        self.planet.mineral_type = planet.mineral_types.index('abundant')
        self.civ.industry_tax = 0.5
        self.assertEqual(5, self.civ.income()) # 2 + 6 hammers * 50%

if __name__ == '__main__':
    unittest.main()

