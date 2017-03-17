#!/usr/bin/env python
# -*- coding: utf-8 -*-

class TransportMixin(object):

    def __init__(self):
        super(TransportMixin, self).__init__()
        self.population_cargo = 0

    @property
    def max_population_cargo(self):
        raise NotImplementedError('TransportMixin.max_population_cargo in'
            ' {0}'.format(self.__class__))

    @property
    def population_cargo(self):
        return self._population_cargo

    @population_cargo.setter
    def population_cargo(self, amount):
        if amount > self.max_population_cargo:
            print ' - Sorry, can not fit that many.'
        self._population_cargo = amount

    @property
    def available_population_cargo(self):
        return self.max_population_cargo - self.population_cargo

