#!/usr/bin/env python
# -*- coding: utf-8 -*-

class PlanetQueue(object):

    def __init__(self):
        self.q = []
        self.repeat = False

    def add(self, building):
        self.q.append(building)

    def pop(self):
        try:
            return self.q.pop(0)
        except IndexError:
            return None

    def get(self, pos=0):
        try:
            return self.q[pos]
        except IndexError:
            return None

