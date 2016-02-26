#!/usr/bin/python
# -*- coding: utf-8 -*-

"""Splits in-place too long lines in dialogs and titles.

Reads and writes the UTF-8 version.  Uses per-language charsets to convert
strings to 8 bits first and then applies the character widths from the parsed
big.fon and small.fon files from the corresponding directory.
"""

import codecs
import os
import re
import struct

import draci_charsets


# Required source path with the game scripts stored in UTF-8.  The individual
# language variants are in its sub-directories cz, en, ...
script_path = '../game-scripts'

# End-of-line convention for the output, but input is automatic.
eoln = '\r\n'


def ParseFontWidths(file):
  fi = open(file)
  data = fi.read(140)
  widths = struct.unpack('B' * 138, data[2:140])
  fi.close()
  return widths


def CharOrdinal(c):
  if 32 <= ord(c) < 128:
    return ord(c) - 32
  else:
    return ordinal_map[c] - 32
    # And throw an assert if not present.  In particular, reject tabs.


def BreakLongLine(line, widths, just_shorten=False):
  char_widths = [widths[CharOrdinal(c)] for c in line]

  total_width = 0
  for w in char_widths:
    total_width += w
  limit = 320
  if just_shorten:
    smaller_limit = limit - 13
  else:
    smaller_limit = limit

  if total_width > limit:
    print '  Breaking line of width %d: %s' % (total_width, line)
    pos = len(line) - 1
    while line[pos] != ' ' or total_width > smaller_limit:
      total_width -= widths[CharOrdinal(line[pos])]
      pos -= 1
    if just_shorten:
      line = line[:pos] + ' ...'
    else:
      line = line[:pos] + '|' + line[pos+1:]
    print '  --> width %d: %s' % (total_width, line)

  return line

def BreakLongLines(s, widths):
  lines = s.split('|')
  return '|'.join([BreakLongLine(line, widths) for line in lines])

def ReformatSentence(s, indentation):
  return re.sub(r'\|([^ ])',	# don't replace | followed by a space or at the end
		lambda m: eoln + (' ' * indentation) + m.group(1),
		s)

def ReformatLines(lines):
  speaking = None
  output = []

  begin_speak_re = re.compile(r'^([^{"]*): *"(.*)$')
  end_speak_re = re.compile(r'^([^"]*)"$')
  title_re = re.compile(r'^( *title) *(.*[^ ]) *$', re.I)
  for line in lines:
    line = draci_charsets.StripEOL(line)
    if speaking is None:
      m = begin_speak_re.match(line)
      if not m:
	m = title_re.match(line)
	if m:
	  line = m.group(1) + ' ' + BreakLongLine(m.group(2), widths_small, just_shorten=True)
	output.append(line + eoln)
	continue
      output.append(m.group(1) + ': "')
      indentation = len(output[-1])
      line = m.group(2)
      speaking = ''
    else:
      speaking += '|'
      line = line.lstrip()	# continuation lines ignore left spaces

    m = end_speak_re.match(line)
    if m:
      line = m.group(1)
    speaking += line
    if m:
      broken = BreakLongLines(speaking, widths_big)
      formatted = ReformatSentence(broken, indentation)
      output.append(formatted + '"' + eoln)
      speaking = None

  assert speaking is None
  return output


def ReformatScript(path):
  # 'U' means convert CR and CR+LF automatically to \n
  lines = codecs.open(path, mode='rU', encoding='utf-8').readlines()

  reformatted_lines = ReformatLines(lines)

  fo = codecs.open(path, mode='w+', encoding='utf-8')
  fo.write(''.join(reformatted_lines))
  fo.close()


# Reformat all language variants into the destination directory
for language, charset in draci_charsets.CHARSET_FOR_LANGUAGE.iteritems():
  source_path = script_path + '/' + language
  raw_files = scripts = 0
  ordinal_map = draci_charsets.CharsetToOrdinalMap(charset)
  widths_big = ParseFontWidths(source_path + '/big.fon')
  widths_small = ParseFontWidths(source_path + '/small.fon')
  for file in os.listdir(source_path):
    if file.endswith('.fon') or file.startswith('RETEZCE') or file.startswith('TITLE'):
      raw_files += 1
    else:
      try:
	ReformatScript(source_path + '/' + file)
      except (UnicodeDecodeError, KeyError), e:
	print 'In file %s/%s: %s' % (source_path, file, str(e))
      scripts += 1
  print 'Language %s: %d scripts and %d raw files' % (language, scripts, raw_files)
