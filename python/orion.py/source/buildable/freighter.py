#!/usr/bin/env python
# -*- coding: utf-8 -*-

from buildable.buildablemixin import BuildableMixin
from buildable.freightermixin import FreighterMixin

class Freighter(BuildableMixin, FreighterMixin):

    def __init__(self):
        super(Freighter, self).__init__()

    @property
    def cost(self):
        return 1

    @property
    def name(self):
        return 'Small Freighter Fleet'

    @property
    def freighter_points(self):
        return 5

