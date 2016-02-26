#!/usr/bin/python
# -*- coding: utf-8 -*-

"""Prunes Dragon History source files, from old-gfx.zip to new-gfx.zip.

Scrapes the game scripts, generates a list of files needed from old-gfx.zip,
and copies only those files into a new subtree that will form new-gfx.zip.
Then it reads all language variants of the game scripts stored in UTF-8,
recodes them into their corresponding charsets, and copies them to the
destination directory, too, so that the game sources are complete.
"""

import codecs
import getopt
import os
import re
import sys

import draci_charsets

# Required source path with the game scripts stored in UTF-8.  The individual
# language variants are in its sub-directories cz, en, ...
script_path = '../game-scripts'
# Optional source path with the expanded old-gfx.zip archive.  If empty, then
# the file pruning/copying phase is skipped and only the game scripts are
# recoded into their respective charsets.
gfx_path = None
# The destination path for the pruned/recoded game files
pruned_path = '../game-scripts/gfx'
# The path to the source code of the player.  The localized strings are read
# from utf-8/texts-*.pas and written to recoded/texts-*.pas.
player_path = '../player'

def AppendIncludesFrom(path, includes):
  print 'Getting includes from', path
  # Regular expressions are greedy
  include_re = re.compile(r'[^{]*[ \t"](\.\.\\.*)\\([^"]*)')
  for line in open(path):
    m = include_re.match(line.rstrip().lower())
    if m:
      dir, pattern = m.groups()
      cleaned_dir = re.sub(r'\\', '/', dir[3:])
      includes.setdefault(cleaned_dir, set()).add(pattern)


def CopyFile(src, dest):
  open(dest, 'w+').write(open(src).read())


def CopyFiles(directory, patterns, destination):
  copied = 0
  used_patterns = set()
  try:
    # TODO: recognize also upper-case file names from the original archive
    # old-gfx.zip; when unpacked on case-sensitive file-systems, they won't
    # match otherwise.  we cannot just take file.lower() below, because also
    # the directory names may be upper-cased.
    for file in os.listdir(directory):
      found = False
      if file in patterns:
	used_patterns.add(file)
	found = True
      elif '.' in file:
	dot_pos = file.rindex('.')
	file_base = file[:dot_pos]
	file_ext = file[dot_pos+1:]
	if file_base in patterns and file_ext not in ['txt', 'bak']:
	  # The two excluded file extensions are for filtering relict files
	  # from old-gfx.zip which have the same basename as some animation.
	  # The real .txt files with the dialogs are always referred to by the
	  # full name and thus are handled by another branch of the top if.
	  used_patterns.add(file_base)
	  found = True
      if found:
	CopyFile(directory + '/' + file, destination + '/' + file)
	copied += 1
  except OSError, e:
    print e
  missing_patterns = patterns - used_patterns
  if missing_patterns:
    print 'Missing', missing_patterns
  return copied, len(missing_patterns)


def SafeMkDir(path, subpath):
  for element in subpath.split('/'):
    path += '/' + element
    try:
      os.mkdir(path)
    except OSError, e:
      if e.errno != 17:		# directory already exists
	raise e


KAMENICKY_MAP = draci_charsets.CharsetToCharMap(draci_charsets.KAMENICKY_CHARS)

def RecodeScript(input_file, char_map, output_file):
  fi = codecs.open(input_file, mode='r', encoding='utf-8')
  output_lines = []
  for line in fi:
    try:
      if '{' not in line or '{#' in line:
	recoded = draci_charsets.RecodeStringFromUTF8(line, char_map)
      else:
	# According to grep, there is never a '{' inside a string, so we don't
	# have to test it.  Comments are in Czech, unless they start with '{#'.
	# We recode comments into KAMENICKY, because they are not contained in
	# the Polish map.
	index = line.index('{')
	recoded = (
	    draci_charsets.RecodeStringFromUTF8(line[:index], char_map) +
	    draci_charsets.RecodeStringFromUTF8(line[index:], KAMENICKY_MAP))
    except KeyError, e:
      print 'KeyError %s on line %s' % (str(e), line),
      raise e
    output_lines.append(recoded)
  fi.close()

  fo = codecs.open(output_file, mode='w+', encoding=draci_charsets.PLACEHOLDER_CHARSET)
  fo.write(''.join(output_lines))
  fo.close()


### main()

try:
  opts, args = getopt.getopt(
      sys.argv[1:],
      'g:s:o:p:',
      ['gfx=', 'scripts=', 'output=', 'player='])
except getopt.GetoptError, err:
  print str(err)
  sys.exit(2)
for o, a in opts:
  if o in ('-g', '--gfx'):
    gfx_path = a
  elif o in ('-s', '--scripts'):
    script_path = a
  elif o in ('-o', '--output'):
    pruned_path = a
  elif o in ('-p', '--player'):
    player_path = a

if gfx_path:
  # Fail if gfx_path doesn't exit
  os.listdir(gfx_path)

  # Get the list of directories and requested files (resp. file groups) in them
  includes = {}
  for file in os.listdir(script_path + '/en'):
    if not file.endswith('.fon'):
      AppendIncludesFrom(script_path + '/en/' + file, includes)
  print 'Found', len(includes), 'directories'

  # Copy the desired files into the destination directory
  patterns = total_copied = total_missing = 0
  SafeMkDir(pruned_path, '')
  for dir, files in sorted(includes.iteritems()):
    SafeMkDir(pruned_path, dir)
    copied, missing  = CopyFiles(gfx_path + '/' + dir, files,
				 pruned_path + '/' + dir)
    print '[%3d, %3d, %3d] in %s' % (len(files), copied, missing, dir)
    patterns += len(files)
    total_copied += copied
    total_missing += missing
  print '=============='
  print 'PATT FILE MISS'
  print '[%3d,%4d, %3d] in TOTAL' % (patterns, total_copied, total_missing)

# Transcode all language variants into the destination directory
SafeMkDir(pruned_path, '')
SafeMkDir(player_path, 'recoded')
for language, charset in draci_charsets.CHARSET_FOR_LANGUAGE.iteritems():
  char_map = draci_charsets.CharsetToCharMap(charset)
  SafeMkDir(pruned_path, language)
  source_path = script_path + '/' + language
  destination_path = pruned_path + '/' + language
  raw_files = scripts = 0
  for file in os.listdir(source_path):
    if file.endswith('.fon') or file.startswith('RETEZCE') or file.startswith('TITLE'):
      CopyFile(source_path + '/' + file, destination_path + '/' + file)
      raw_files += 1
    else:
      try:
	RecodeScript(source_path + '/' + file, char_map, destination_path + '/' + file)
      except (UnicodeDecodeError, KeyError), e:
	print 'In file %s/%s: %s' % (source_path, file, str(e))
      scripts += 1
  print 'Language %s: %d scripts and %d raw files' % (language, scripts, raw_files)

  player_texts_file = player_path + '/utf-8/texts-%s.pas' % language
  try:
    RecodeScript(player_texts_file, char_map, player_path + '/recoded/texts-%s.pas' % language)
  except (UnicodeDecodeError, KeyError), e:
    print 'In file %s: %s' % (player_texts_file, str(e))
  print 'Language %s player texts recoded' % language
