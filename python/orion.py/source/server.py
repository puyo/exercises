#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Server(object):

    def __init__(self):
        self.players = []
        self.universe = None

    def read_packets(self):
        pass

    def parse_packet(self, packet):
        func = getattr(self, packet.type)
        func(self, packet)

    def targeted_packet(self, player, packet):
        # TODO
        pass

    def broadcast_packet(self, packet):
        for player in self.players:
            self.targeted_packet(player, packet)

    # Receivable Messages
    # ---------------------------------------------------------------------------

    def msg(self, p):
        self.messages.append(p)
        self.send_packet(p)

