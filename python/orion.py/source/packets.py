#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Packet(object):
    def __init__(self, **kwargs):
        self.update(kwargs)

class MessagePacket(Packet):
    type = 'msg'
    fields = 'text',

