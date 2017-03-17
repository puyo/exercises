#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Notes
# -----
#
# Credits are integers measured in a currency called "BC" for "billion
# credits". Think of them like galaxy-sized space bucks.
#
# Basics of income is
#
#     1 credit per worker
#     + (tax rate * hammers)
#  
# Income is spent on maintenance which is basically the sum of the maintenance
# costs of your buildings ... TODO and military excess - greg
#
# There are other things that can mess with it like heroes salaries and
# megawealth.
#
# Reference: http://www.gamefaqs.com/computer/doswin/file/197873/14668

class CivFinanceMixin(object):
    def __init__(self):
        super(CivFinanceMixin, self).__init__()
        self.industry_tax = 0.0
        self.credits = 0

    def profit(self):
        return self.income() - self.maintenance()

    def income(self):
        return self.income_from_planets() \
                + self.income_from_heroes()

    def maintenance(self):
        return self.maintenance_for_military() \
                + self.maintenance_for_buildings() \
                + self.maintenance_for_heroes

    def income_from_heroes(self):
        return sum([h.megawealth for h in self.heroes])

    def income_from_planets(self):
        return sum([p.income() for p in self.planets])

    def maintenance_for_military(self):
        return self.maintenance_for_excess_ships() # see command_points.py

    def maintenance_for_buildings(self):
        return sum([p.maintenance() for p in self.planets])

    def maintenance_for_heroes(self):
        return sum([h.salary for h in self.heroes])

    def update_credits(self):
        self.credits += self.income()

class PlanetFinanceMixin(object):
    def __init__(self):
        super(PlanetFinanceMixin, self).__init__()

    def profit(self):
        return self.income() - self.maintenance()

    def income(self):
        return self.income_from_population() \
                + self.income_from_industry_tax()

    def income_from_population(self):
        return self.potential_workers 

    def income_from_industry_tax(self):
        return int(self.hammers_produced * self.owner.industry_tax)

    def hammers_lost_to_industry_tax(self):
        return self.income_from_industry_tax()

    def maintenance(self):
        sum = 0
        for b in self.buildings:
            if hasattr(b, 'maintenance'):
                sum += b.maintenance
        return sum
