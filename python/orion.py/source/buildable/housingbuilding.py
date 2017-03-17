#!/usr/bin/env python
# -*- coding: utf-8 -*-

from buildable.buildablemixin import BuildableMixin

class HousingBuilding(BuildableMixin):

    def __init__(self):
        super(HousingBuilding, self).__init__()

    @property
    def cost(self):
        return 0

    @property
    def name(self):
        return 'Housing'


