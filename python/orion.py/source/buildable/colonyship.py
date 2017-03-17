#!/usr/bin/env python
# -*- coding: utf-8 -*-

from buildable.buildablemixin import BuildableMixin
from buildable.shipmixin import ShipMixin
from buildable.transportmixin import TransportMixin

class ColonyShip(BuildableMixin, ShipMixin, TransportMixin):

    def __init__(self):
        super(ColonyShip, self).__init__()
        self.unique_per_planet = False

    @property
    def cost(self):
        return 1

    @property
    def name(self):
        return 'Colony Ship'

    @property
    def max_population_cargo(self):
        return 2

    @property
    def command_points(self):
        return 1
