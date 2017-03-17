#!/usr/bin/env python
# -*- coding: utf-8 -*-

from buildable.buildablemixin import BuildableMixin

class CloningBuilding(BuildableMixin):

    def __init__(self):
        super(CloningBuilding, self).__init__()

    @property
    def cost(self):
        return 10

    @property
    def name(self):
        return 'Cloning Center'

    @property
    def population_growth_perc(self):
        return 1.05

