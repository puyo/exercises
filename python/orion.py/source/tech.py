#!/usr/bin/env python
# -*- coding: utf-8 -*-

from abc import abstractmethod

# Notes
# -----
#
# Reference: http://www.gamefaqs.com/computer/doswin/file/197873/14668

ladders = []

class Tech(object):
    def __init__(self, name, on_learn):
        super(Tech, self).__init__()
        self.name = name
        self.on_learn = on_learn

class TechLevel(object):
    def __init__(self, name, research_points, techs):
        super(TechLevel, self).__init__()
        self.name = name
        self.research_points = research_points
        self.techs = techs

class TechLadder(object):
    def __init__(self, name, levels):
        super(TechLadder, self).__init__()
        self.name = name
        self.levels = levels

class CivTechMixin(object):
    def __init__(self):
        super(CivTechMixin, self).__init__()
        self.techs = set()
        self.buildables = []
        self.ship_systems = []

    def learn_tech(self, tech):
        self.techs.append(tech)
        tech.on_learn(self)

    def enable_building(self, buildable):
        self.buildables.append(buildable)

    def enable_ship_system(self, system):
        self.ship_systems.append(system)

def tech_for_building(building):
    def on_learn(civ):
        civ.enable_building(building)
    return Tech(building.name, on_learn)

def tech_for_ship_system(system):
    def on_learn(civ):
        civ.enable_ship_system(system)
    return Tech(system.name, on_learn)

def tech_level(name, research_points, techs):
    return TechLevel(name, research_points, techs)

def tech_ladder(name, levels):
    result = TechLadder(name, levels)
    ladders.append(result)
    return result
