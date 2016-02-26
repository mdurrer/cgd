#!/usr/bin/python
# -*- coding: utf-8 -*-
"""Renames identifiers in-place in files specified on the command-line."""

import re
import sys


def ReadRenames(filename):
  """Returns a dictionary mapping old identifiers to new."""
  renames = {}
  line_number = 0
  for line in open(filename):
    line_number += 1
    if not line.strip() or line.startswith('#'):
      continue
    try:
      old, new = line.split()
      if old.lower() in renames:
	raise Exception('%s has already been defined' % old)
      renames[old.lower()] = new
    except Exception, e:
      print 'Error %s on line #%d: %s' % (e, line_number, line)
      raise
  return renames


ALPHAS = 'a-zA-Z0-9_'
ALPHAS += 'áčďéěíňóřšťúůýž'
ALPHAS += 'ÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ'


def RenameTokens(tokens, renames, used):
  """Transforms a list of tokens.

  Args:
    tokens: list of strings
    renames: a dictionary of the renames
    used: a writable dictionary of reverse renames for tracking whether there
	is no collision

  Returns:
    list of renamed tokens

  Raises:
    Exception: if a collision is found
  """
  renamed_tokens = []
  for token in tokens:
    if token.lower() not in renames:
      renamed_tokens.append(token)
      continue
    renamed = renames[token.lower()]
    if renamed not in used:
      used[renamed] = token.lower()
    else:
      if used[renamed] != token.lower():
	raise Exception('Both %s and %s are renamed to %s' %
			(used[renamed], token, renamed))
    renamed_tokens.append(renamed)
  return renamed_tokens


def TransformFile(renames, filename):
  try:
    output = []
    used = {}
    line_number = 0
    for line in open(filename):
      line_number += 1
      tokens = re.findall('[^%s]+|[%s]+' % (ALPHAS, ALPHAS), line)
      assert line == ''.join(tokens)
      try:
	output.append(''.join(RenameTokens(tokens, renames, used)))
      except Exception, e:
	raise Exception('%s on %s:%d' % (e, filename, line_number))
    open(filename, 'w').write(''.join(output))
  except Exception, e:
    print e
    raise

########## Main program

renames = ReadRenames('scripts/renames.txt')
for file in sys.argv[1:]:
  TransformFile(renames, file)
  print 'Transformed', file
