#!/usr/bin/env python
# -*- coding: utf-8 -*-

class FreighterMixin(object):

    def __init__(self):
        super(FreighterMixin, self).__init__()
    
    @property
    def freighter_points(self):
        raise NotImplementedError('FreighterMixin.freighter_points')

