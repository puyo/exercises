#!/usr/bin/env python
# -*- coding: utf-8 -*-

from ship_template import ShipTemplate

class BuildingFactory(object):

    @staticmethod
    def get(name, civ):
        try:
            # select where ship.name == name, next() raises StopIteration
            # unless there was at least one match.
            return (a for a in civ.ship_template_slots if a.name == name).next()
        except:
            # XXX: make sure the civ has access to the tech
            modname = 'buildable.' + name.lower()
            mod = __import__(modname, globals(), locals())
            mod = getattr(mod, name.lower())
            cls = getattr(mod, name)
            return cls()

