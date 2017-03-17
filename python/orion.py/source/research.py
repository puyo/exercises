#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Notes
# -----
#
# Reference: http://www.gamefaqs.com/computer/doswin/file/197873/14668

class CivResearchMixin(object):
    def __init__(self):
        super(CivResearchMixin, self).__init__()

    def research_points(self):
        return self.research_points_from_planets() \
                + self.research_points_from_ships()

    def research_points_from_planets(self):
        return sum([p.research_points() for p in self.planets])

    def research_points_from_ships(self): # TODO
        return 0

class PlanetResearchMixin(object):
    def __init__(self):
        super(PlanetResearchMixin, self).__init__()

    def research_points(self):
        research_per_scientist = 3
        from_scientists = self.scientists * research_per_scientist
        # intelligence bonus

        # buildings
        from_buildings = 0
        for b in self.buildings:
            if hasattr(b, 'research_points'):
                from_buildings += b.research_points
        # TODO: if this planet has Artifacts, +2 research
        # TODO: leader effects
        # TODO: gravity penalty
        # TODO: government
        sum = from_scientists + from_buildings
        return sum
