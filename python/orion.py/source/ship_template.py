#!/usr/bin/env python
# -*- coding: utf-8 -*-

from buildable.buildablemixin import BuildableMixin

# ships have:
# name
# hull: ['BB', 'CA', 'CL', 'DD', 'FG']
# weapons: [weapon]
# capacity
# 

class ShipTemplate(BuildableMixin):

    def __init__(self):
        super(ShipTemplate, self).__init__()
        self.name = None

    @property
    def cost(self):
        return 100

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, v):
        self._name = v

    def configure(self):
        return self

