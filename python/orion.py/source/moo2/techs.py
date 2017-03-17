#!/usr/bin/env python
# -*- coding: utf-8 -*-

import tech
from moo2 import buildings
from moo2 import ships
from moo2 import ship_systems

# Notes
# -----
#
# Reference: http://www.gamefaqs.com/computer/doswin/file/197873/14668

colony_base = tech.tech_for_building(buildings.colony_base)
star_base = tech.tech_for_building(buildings.star_base)
marine_barracks = tech.tech_for_building(buildings.marine_barracks)

anti_missile_rockets = \
        tech.tech_for_ship_system(ship_systems.anti_missile_rockets)
fighter_bays = tech.tech_for_ship_system(ship_systems.fighter_bays)
reinforced_hull = tech.tech_for_ship_system(ship_systems.reinforced_hull)

automated_factory = tech.tech_for_building(buildings.automated_factory)
missile_base = tech.tech_for_building(buildings.missile_base)
heavy_armor = tech.tech_for_ship_system(ship_systems.heavy_armor)

engineering0 = tech.tech_level('Engineering', 
        research_points=0,
        techs=[colony_base, star_base, marine_barracks])
engineering1 = tech.tech_level('Advanced Engineering',
        research_points=80,
        techs=[anti_missile_rockets, fighter_bays, reinforced_hull])
engineering2 = tech.tech_level('Advanced Construction',
        research_points=150, 
        techs=[automated_factory, missile_base, heavy_armor])

engineering_ladder = tech.tech_ladder('Engineering', 
        [engineering0, engineering1, engineering2])
