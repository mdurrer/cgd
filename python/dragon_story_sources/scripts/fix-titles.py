#!/usr/bin/python
# -*- coding: utf-8 -*-

"""Translates titles given a TSV file, or replaces them by numbers.

This utility can read a TSV file describing how to change which title (with the
remaining titles left unchanged).  Example usage:

./fix-titles.py \
    -i../game-scripts/en \
    -u../game-scripts/en-tran \
    -m TITLEreplacement.txt

It can also replace each title by its index in its script file.  This is useful
when one tries to compare the game scripts for two distinct language versions
using the standard diff command and spot the real differences (such as broken
GPL2 commands).  Different titles would pollute the diff's output.  Example usage:

./fix-titles.py \
    -i../game-scripts/en \
    -u../game-scripts/en-tran

It can also replace each title by the corresponding title in another directory
(assuming that they are related 1:1, which is checked).  This is useful in
a similar situation like above, when the diff's don't touch the titles, but
the changed lines are close to the titles and therefore the context diff
doesn't match.

./fix-titles.py \
    -i../game-scripts/en \
    -u../game-scripts/en-tran
    -t../game-scripts/de

"""

import getopt
import os
import re
import sys

import draci_charsets

# Input and output directories for the fixed game scripts.
input_path = '../game-scripts/en'
output_path = '../game-scripts/en-tran'
title_path = None

# Name of the TSV file with editted titles, or None.
mapping_file = None

def ReadMapping(mapping_filename):
  mapping = {}
  for line in open(mapping_filename):
    line = line.strip()
    if not line:
      continue
    try:
      orig, tran = line.split('\t')
    except ValueError, e:
      print '!%s!' % line
      raise e
    if (orig.endswith('.TXT') or orig.startswith('TITLE') or
	re.match(r'^[A-Z]*$', orig)):
      print 'Ignoring', line
      continue
    mapping[orig] = tran
  return mapping


def TranslateFile(input_file, output_file, mapping, title_file=None):
  print 'Reading file', input_file
  output = []

  title_re = re.compile(r'^( *title) *(.*[^ ]|) *$', re.I)

  if title_file is not None:
    titles = []
    for line in open(title_file, 'U').readlines():
      line = draci_charsets.StripEOL(line)
      m = title_re.match(line)
      if m:
	titles.append(line)
  else:
    titles = None

  title_index = 0
  for line in open(input_file, 'U').readlines():
    line = draci_charsets.StripEOL(line)
    m = title_re.match(line)
    if m:
      if mapping is not None:
	if m.group(2) in mapping:
	  line = m.group(1) + ' ' + mapping[m.group(2)]
	  del mapping[m.group(2)]
      else:
	if titles is None:
	  line = 'TITLE #%d' % (title_index + 1)
	else:
	  line = titles[title_index]
	title_index += 1

    output.append(line + '\r\n')

  output[-1] = output[-1][:-1]		# crop the final \n
  if titles is not None:
    assert title_index == len(titles)

  print 'Writing file', output_file
  fo = open(output_file, 'w+')
  print >>fo, ''.join(output)
  fo.close()


### main()

try:
  opts, args = getopt.getopt(
      sys.argv[1:],
      'i:u:m:t:',
      ['input=', 'output=', 'mapping=', 'titles='])
except getopt.GetoptError, err:
  print str(err)
  sys.exit(2)
for o, a in opts:
  if o in ('-i', '--input'):
    input_path = a
  elif o in ('-u', '--output'):
    output_path = a
  elif o in ('-m', '--mapping'):
    mapping_file = a
  elif o in ('-t', '--titles'):
    title_path = a

if mapping_file:
  mapping = ReadMapping(mapping_file)
else:
  mapping = None

for file in os.listdir(input_path):
  if file.endswith('.fon') or file.startswith('RETEZCE') or file.startswith('TITLE'):
    pass
  else:
    if title_path is not None:
      title_file = os.path.join(title_path, file)
    else:
      title_file = None
    TranslateFile(os.path.join(input_path, file),
	          os.path.join(output_path, file),
		  mapping, title_file=title_file)
if mapping:
  print 'Unused mappings', mapping
