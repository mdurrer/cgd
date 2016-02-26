#!/usr/bin/python

"""Computes maximal length of a line in each text file.

Meant to run on the result of `grep -i title $lang/{ikony,objekty} |
sed -e 's/^ *title *//i'`, so that we can compute the maximal length of game
item's or object's title and compare it to the limit of the k3 compiler.
"""

import codecs
import sys

for file in sys.argv[1:]:
  lengths = []
  for line in codecs.open(file, 'r', encoding='utf-8'):
    lengths.append(len(line))
  print file, ': ', max(lengths)
