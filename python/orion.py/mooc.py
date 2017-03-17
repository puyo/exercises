#!/usr/bin/env python
# -*- coding: utf-8 -*-

from os import path
import sys

ROOT = path.join(path.abspath(path.dirname(__file__)), 'source')
sys.path.insert(0, ROOT)

if sys.hexversion < 0x02060000:
    print 'You must have Python 2.6 to run this'
    sys.exit(1)

from main import Main

Main().loop()
