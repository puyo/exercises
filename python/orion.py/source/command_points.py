#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Notes
# -----
#
# All civs start with 5 base command points
#
# Frigate -1
# Destroyer -2
# Cruiser -3
# Battleship -4
# Titan Ship -5
# Doom Star -6
# Star Base +1
# Battlestation +2
# Star Fortress +3
# Tachyon Comm +1/base[1]
# Subspace Comm +2/base[1]
# Hyperspace Comm +3/base[1]
# Imperium Government pick +50%
# Warlord pick +2/colony
#
# [1] "base" means a Star Base, Battlestation or Star Fortress

# Non combat ship -1
# Frigate -1
# Destroyer -2
# Cruiser -3
# Battleship -4
# Titan Ship -5
#
# If you don't have enough command points for the ships you've built, you have
# to spend 10 BC for each command point lacking (pretty severe)

class CivCommandPointsMixin(object):
    def __init__(self):
        super(CivCommandPointsMixin, self).__init__()
        self.base_command_points = 5

    def command_points(self):
        total = self.base_command_points \
                + command_points_from_bases()
        #if self.techs.has(tech.tachyon_communication): # TODO
            #total += self.num_bases()
        #if self.government == governments.imperium: # TODO
            #total *= 1.5
        return total

    def command_points_from_bases(self):
        sum = 0
        for p in self.planets:
            for b in p.buildings:
                if hasattr(b, 'command_points'):
                    sum += b.command_points
        return sum

    def command_points_spent(self):
        return command_points_spent_on_ships()

    def command_points_spent_on_ships(self):
        sum = 0
        for s in self.ships:
            if hasattr(s, 'command_points'):
                sum += s.command_points
        return sum

    def maintenance_for_excess_ships(self):
        total = self.command_points() - self.command_points_spent()
        if total < 0:
            return -total * 10
        return 0
