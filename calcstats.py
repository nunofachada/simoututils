#!/usr/bin/env python

from pylab import *

data = loadtxt('stats.txt')
sheep = data[:, 0]
wolves = data[:, 1]
grass = data[:, 2]
