#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Ship(object):
    def __init__(self):
        super(Ship, self).__init__()

class NonCombatShip(Ship):
    def __init__(self):
        super(NonCombatShip, self).__init__()
        self.command_points = 1

class CombatShip(Ship):
    def __init__(self):
        super(CombatShip, self).__init__()
        self.size = 1
