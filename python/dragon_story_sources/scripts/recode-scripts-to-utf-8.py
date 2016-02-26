#!/usr/bin/python
# -*- coding: utf-8 -*-

"""Recodes our funny 8-bit charsets to UTF-8."""

import codecs
import getopt
import os
import sys

import draci_charsets

# Input and output directories for the fixed game scripts.  If input_path is
# non-empty, then all script files from that directory are converted.  In any
# case, all files from the command line are converted.  If output_path is
# empty, then the converted files override the original version, otherwise
# each input file name is written to the output_path directory.
input_path = ''
output_path = ''

# Charset for which language to use for the files above.  It must be
# specified.
CHARSET = None

def RecodeFile(input_file):
  if not output_path:
    output_file = input_file
    print 'Recoding', input_file
  else:
    output_file = os.path.join(output_path, os.path.basename(input_file))
    print 'Recoding', input_file, 'into', output_file

  output_lines = []
  # Without any encoding specified, the read strings consit of "generic" 8-bit
  # characters, and we only apply ord() on the high ones, so it seems to be
  # OK.
  for line in open(input_file):
    if '{' not in line or '{#' in line:
      recoded = draci_charsets.RecodeStringToUTF8(line, CHARSET)
    else:
      # According to grep, there is never a '{' inside a string, so we don't
      # have to test it.  Comments are in Czech, unless they start with '{#'.
      index = line.index('{')
      recoded = (
	  draci_charsets.RecodeStringToUTF8(line[:index], CHARSET) +
	  draci_charsets.RecodeStringToUTF8(line[index:], draci_charsets.KAMENICKY_CHARS))
    output_lines.append(recoded)

  fo = codecs.open(output_file, mode='w', encoding='utf-8')
  fo.write(''.join(output_lines))
  fo.close()


### main()

try:
  opts, args = getopt.getopt(
      sys.argv[1:],
      'i:o:c:',
      ['input=', 'output=', 'charset='])
except getopt.GetoptError, err:
  print str(err)
  sys.exit(2)
for o, a in opts:
  if o in ('-i', '--input'):
    input_path = a
  if o in ('-o', '--output'):
    output_path = a
  elif o in ('-c', '--charset'):
    CHARSET = draci_charsets.CHARSET_FOR_LANGUAGE[a]
assert CHARSET

if input_path:
  for file in os.listdir(input_path):
    if file.endswith('.fon') or file.startswith('RETEZCE') or file.startswith('TITLE'):
      pass
    else:
      RecodeFile(os.path.join(input_path, file))
for file in args:
  if not file.endswith('.fon'):
    RecodeFile(file)
