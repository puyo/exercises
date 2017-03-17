#!/usr/bin/env python
# -*- coding: utf-8 -*-

import building

# -------------------------------------------------------------------
class ColonyBase(building.Building):
    """
    Creates a colony on another planet inside the same star system as the
    building colony.
    """
    name = 'Colony Base'
    cost = 200
    maintenance = 0

    def __init__(self):
        super(building.Building, self).__init__()

    @classmethod
    def on_build(self, planet):
        pass #ui.colony_base_dialog(planet.star) # TODO

    @classmethod
    def can_build(self, planet):
        def habitable(planet):
            return not planet.owner # TODO and not gas giant
        return any(filter(habitable, planet.star.planets))

# -------------------------------------------------------------------
class AutomatedFactory(building.Building):
    """
    Generates 5 production and increases the production each worker generates
    by +1.
    """

    def __init__(self):
        super(building.Building, self).__init__()
        self.name = 'Automated Factory'
        self.cost = 60
        self.maintenance = 1

    def can_build(self, planet):
        return self.not_already_built(planet)

    def on_build(self, planet):
        pass
