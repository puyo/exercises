#!/usr/bin/env python
# -*- coding: utf-8 -*-

import ship

# -------------------------------------------------------------------
colony_ship = ship.non_combat_ship('Colony Ship',
        cost=500,
        can_build=ship.can_always_build,
        on_reach_destination=colony_ship_on_reach_destination,
        desc="Capable of creating a colony in a distant star system. " \
                "Will not engage in combat and will be destroyed when " \
                "attacked if not escorted by a military ship.")

def colony_ship_on_reach_destination(self, star):
    pass # colonise dialog UI

# -------------------------------------------------------------------
