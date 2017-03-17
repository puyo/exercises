#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
import math

class Position(object):

    __slots__ = ('x', 'y')

    def __init__(self, *pos):
        if isinstance(pos[0], tuple):
            self.x = pos[0][0]
            self.y = pos[0][1]
        elif len(pos) == 2:
            self.x = pos[0]
            self.y = pos[1]

    @staticmethod
    def random(pos):
        return Position(random.uniform(0, pos.x), random.uniform(0, pos.y))

    def normalise(self):
        a = math.atan2(self.y, self.x)
        self.x = math.cos(a)
        self.y = math.sin(a)
    
    def distance_to(self, o):
        return math.hypot(self.x - o.x, self.y - o.y)

    def to_tuple(self):
        return (self.x, self.y)

    def __str__(self):
        return '(%f,%f)' % (self.x, self.y)

    def __add__(self, o):
        return Position(self.x + o.x, self.y + o.y)

    def __sub__(self, o):
        return Position(self.x - o.x, self.y - o.y)

    def __mul__(self, o):
        return Position(self.x * o, self.y * o)


