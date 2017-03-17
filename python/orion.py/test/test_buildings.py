#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'source'))

from universe import Universe
from buildable.factory import BuildingFactory

class TestBuildings(unittest.TestCase):
    def test_factory(self):
        universe = Universe()
        civ = universe.add_civ(name='testciv')
        BuildingFactory.get('ColonyShip', civ)
