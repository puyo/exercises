#!/usr/bin/env python
# -*- coding: utf-8 -*-

class BuildableMixin(object):

    def __init__(self):
        super(BuildableMixin, self).__init__()
        self.remaining = self.cost
        self.planet = None
        self.is_complete = False
        self.unique_per_planet = True

    @property
    def cost(self):
        raise NotImplementedError('BuildableMixin.cost')

    @property
    def built(self):
        return self.cost - self.remaining

    def progress(self, amount):
        self.remaining -= amount
        if self.remaining < 0:
            self.remaining = 0

        if self.remaining == 0:
            self.is_complete = True

    def set_complete(self):
        self.remaining = 0
        self.is_complete = True

    @property
    def name(self):
        raise NotImplementedError('Building.name')

    @property
    def maintenance(self):
        raise NotImplementedError('Building.maintenance')

    def __str__(self):
        if self.is_complete:
            return self.name
        return '{0} {1}/{2}'.format(self.name, self.built, self.cost)

    # Planet Modifiers
    # -------------------------------------------------------------------------

    @property
    def population_growth_perc(self):
        return 1.0

