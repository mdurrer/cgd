#!/usr/bin/python
# -*- coding: utf-8 -*-

"""Reformats spoken sentences and optionally translates them.

This utility reads all scripts in a given directory, and (by default) just
reformats all spoken sentences.  It aligns continuation files to the same
column as the first line, and expands |'s.  Example usage:

./fix-translation.py \
    -i../game-scripts/en \
    -u../game-scripts/en-tran

When enabled by parameter -t, the utility also translates each spoken sentence
using a mapping given by a pair of text files.  These files are disassembled
RETEZCE.DFW files and can be obtained using draci_strings_extract.py.  Both
such files must have the same number of lines and the lines in orig_file must
exactly correspond to the spoken sentences in input_path.  The lines in
edit_file can be

(a) just manually editted lines from orig_file, and then a batch replacement in
    the scripts is performed.  This is good when the translator didn't edit the
    scripts directly, but instead editted just the disassembled list of
    sentences.

(b) lines from a different translation, and then the scripts are translated
    using this mapping.  This is good for two possible use cases:
      1. as a starting point for a new translation
      2. for obtaining a variant of the originl scripts translated to a
	 language whose scripts are in progress, so that one can diff this
	 variant to the new language's scripts and verify that there are no
	 differences (such as broken GPL2 commands) other than the actual
	 translation.  You need to run also fix-titles.py to unify the titles
	 in this case, because these are not touched by this utility.

Example usage (have UTF-8 encoded editted files):

./fix-translation.py \
    -i../game-scripts/en \
    -u../game-scripts/en-tran \
    -t \
    -o RETEZCE.TXT.orig \
    -e RETEZCE.TXT.edit

Example usage (have disassembled RETEZCE.DFW's in their native charsets):

./fix-translation.py \
    -i../game-scripts/cz \
    -u../game-scripts/pl-tran \
    -t \
    -o retezce-cz.txt \
    -e retezce-pl.txt \
    -O cz \
    -E pl

"""

import getopt
import os
import re
import sys

import draci_charsets

# Input and output directories for the fixed game scripts.
input_path = '../game-scripts/en'
output_path = '../game-scripts/en-tran'

# Whether to read disassembled text files and use them for fix-ups.  Otherwise
# just reformat the strings.
perform_translation = False

# The file names of text files with disassembled RETEZCE.DFW.
orig_file = 'RETEZCE.TXT.orig'
edit_file = 'RETEZCE.TXT.edit'

# Charset for which language to use for the files above, or None when UTF-8 is assumed.
ORIG_CHARSET = None
EDIT_CHARSET = None

# End-of-line convention for the output, but input is automatic.
eoln = '\r\n'

EMPTY_CONTEXT = ''

def RecodeInputString(s, charset):
  if charset is not None:
    return draci_charsets.RecodeStringToUTF8(
	draci_charsets.StripEOL(s), charset)
  else:
    return draci_charsets.StripEOL(s).decode('utf-8')


class Translation(object):
  def __init__(self, orig):
    self.original = orig
    self.translations = {EMPTY_CONTEXT: []}
    self.instances = 0
    self.used = 0

  def Add(self, sentence, previous):
    self.instances += 1

    translation_list = self.translations.setdefault(previous, [])
    if sentence not in translation_list:
      translation_list.append(sentence)

    translation_list = self.translations[EMPTY_CONTEXT]
    if sentence not in translation_list:
      translation_list.append(sentence)


def ReadMapping(orig, edit):
  orig_sentences = open(orig).readlines()
  edit_sentences = open(edit).readlines()
  assert len(orig_sentences) == len(edit_sentences)
  print 'Read', len(orig_sentences), 'sentences'

  mapping = {}
  previous = EMPTY_CONTEXT
  for orig, edit in zip(orig_sentences, edit_sentences):
    o = RecodeInputString(orig, ORIG_CHARSET)
    e = RecodeInputString(edit, EDIT_CHARSET)
    if o not in mapping:
      mapping[o] = Translation(o)
    mapping[o].Add(e, previous)
    previous = o

  print 'Mapping has size', len(mapping)
  return mapping

def TranslateSentence(sentence, previous, mapping):
  s = sentence.decode('utf-8')	# game-scripts/ are stored in UTF-8
  p = previous.decode('utf-8')
  if perform_translation:
    try:
      # If this sentence is not the first one in the script file, then the
      # previous sentence is used for disambiguation.  It is an error if either
      # of them doesn't exist.
      # If the sentence is first, then we don't have any context and that's why
      # all translation are inserted twice, once with the real context and once
      # with context EMPTY_CONTEXT.
      translation_list = mapping[s].translations[p]
    except KeyError, e:
      print >>sys.stderr, "Cannot find sentence '%s' with previous sentence '%s'" % (s, p)
      raise e

    d = '|@@@|'.join(translation_list)	# the right translation needs to be chosen manually
    mapping[s].used += 1
  else:
    d = s
  return d.encode('utf-8')


def ReformatSentence(s, indentation):
  return re.sub(r'\|([^ ])',	# don't replace | followed by a space or at the end
		lambda m: eoln + (' ' * indentation) + m.group(1),
		s)


def TranslateFile(input_file, output_file, mapping):
  print 'Reading file', input_file
  speaking = None
  previous = EMPTY_CONTEXT
  output = []

  begin_speak_re = re.compile(r'^([^{"]*): *"(.*)$')
  end_speak_re = re.compile(r'^([^"]*)"$')
  # 'U' means convert CR and CR+LF automatically to \n
  for line in open(input_file, 'U').readlines():
    line = draci_charsets.StripEOL(line)
    if speaking is None:
      m = begin_speak_re.match(line)
      if not m:
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
      translated = TranslateSentence(speaking, previous, mapping)
      formatted = ReformatSentence(translated, indentation)
      output.append(formatted + '"' + eoln)
      previous = speaking
      speaking = None

  assert speaking is None
  output[-1] = output[-1][:-1]		# crop the final \n

  print 'Writing file', output_file
  fo = open(output_file, 'w+')
  print >>fo, ''.join(output)
  fo.close()


### main()

try:
  opts, args = getopt.getopt(
      sys.argv[1:],
      'i:u:o:e:O:E:t',
      ['input=', 'output=', 'orig_file=', 'edit_file=',
       'orig_charset=', 'edit_charset=', 'translate'])
except getopt.GetoptError, err:
  print str(err)
  sys.exit(2)
for o, a in opts:
  if o in ('-i', '--input'):
    input_path = a
  if o in ('-u', '--output'):
    output_path = a
  elif o in ('-o', '--orig_file'):
    orig_file = a
  elif o in ('-e', '--edit_file'):
    edit_file = a
  elif o in ('-O', '--orig_charset'):
    if a:
      ORIG_CHARSET = draci_charsets.CHARSET_FOR_LANGUAGE[a]
    else:
      ORIG_CHARSET = None
  elif o in ('-E', '--edit_charset'):
    if a:
      EDIT_CHARSET = draci_charsets.CHARSET_FOR_LANGUAGE[a]
    else:
      EDIT_CHARSET = None
  elif o in ('-t', '--translate'):
    perform_translation = True

if perform_translation:
  mapping = ReadMapping(orig_file, edit_file)
else:
  mapping = {}

for orig, tran in mapping.iteritems():
  if len(tran.translations[EMPTY_CONTEXT]) > 1:
    print >>sys.stderr, orig, '\n', tran.translations, '\n'

for file in os.listdir(input_path):
  if file.endswith('.fon') or file.startswith('RETEZCE') or file.startswith('TITLE'):
    pass
  else:
    TranslateFile(os.path.join(input_path, file),
	          os.path.join(output_path, file),
		  mapping)

for key, value in mapping.iteritems():
  assert value.used == value.instances
print 'Verified that each translation has been used exactly once'
