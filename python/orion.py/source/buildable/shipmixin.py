#!/usr/bin/env python
# -*- coding: utf-8 -*-

class ShipMixin(object):

    def __init__(self):
        super(ShipMixin, self).__init__()

        # Position should only be used when in transit
        # XXX: Maybe this can be either a planet (with a position) or a
        # position
        self.position = None

        # Set to None when docked. self.planet should be set
        self._dest = None

    @property
    def dest(self):
        return self._dest

    @dest.setter
    def dest(self, d):

        # We just need to check if this dest is something that has a position
        # in the Universe. Probably a Star, but we'll just check for the
        # "position" attribute.

        if d and not hasattr(d, 'position'):
            print(' - Sorry, {0} has no position property'.format(d))

        # Set our position to be the planet we're on
        if not self.position:
            self.position = self.planet.position

        # planet only set when at a planet
        self.planet = None

        self._dest = d

        print ' - dest set to', d
        print ' - planet set to', self.planet
        print ' - position is', self.position

    @property
    def dest_distance(self):
        if not self.dest:
            raise Exception('{0} has no destination'.format(self))

        if not self.position:
            raise Exception('{0} has no position'.format(self))

        return self.position.distance_to(self.dest.position)

    @property
    def speed(self):
        return 10

    def update(self):
        if not self.dest:
            return
        
        movement = self.speed

        # We have arrived
        if self.dest_distance <= movement:
            planet = self.dest
            self.dest = None
            self.planet = planet

        else:

            diff = self.dest.position - self.position
            diff.normalise()
            diff *= movement
            self.position += diff

    def __str__(self):
        return 'hah'
