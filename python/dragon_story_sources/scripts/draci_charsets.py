#!/usr/bin/python
# -*- coding: utf-8 -*-

# iso-8859-2 is a fake charset.  We just care to use an 8-bit encoding, rather
# than the default ascii which only holds 7-bits.  After codecs encode it in
# the same encoding, we get exactly the 8 bits we want.
PLACEHOLDER_CHARSET = 'iso-8859-2'

KAMENICKY_CHARS = 'ČüéďäĎŤčěĚĹÍľĺÄÁÉžŽôöÓůÚýÖÜŠĽÝŘťáíóúňŇŮÔšř'.decode('utf-8')
POLISH_CHARS = 'ąćęłńóśźżĄĆĘŁŃÓŚŹŻŽôöÓůÚýÖÜŠĽÝŘťáíóúňŇŮÔšř'.decode('utf-8')
GERMAN_CHARS = 'ČüéďäĎŤčěĚĹÍľĺÄÁÉžŽßöÓůÚýÖÜŠĽÝŘťáíóúňŇŮÔšř'.decode('utf-8')

# Maps language name to the charset used in its the compiled scripts.  If you
# add a new language using a new alphabet, list the sequence of its Unicode
# characters in a string like {KAMENICKY,POLISH}_CHARS above; they will be
# mapped to 8-bit values [128, 129, ...].  Please note that the maximal ordinal
# value of a character must be at most 169; the game player doesn't support the
# full 8-bit set.  After allocating the characters, edit small.fon and big.fon
# using fontedit.exe so that it contains glyphs for these characters.
CHARSET_FOR_LANGUAGE = {
    'cz': KAMENICKY_CHARS,
    'en': KAMENICKY_CHARS,  # pure ASCII is not enough due to diacritics in credits
    'pl': POLISH_CHARS,
    'de': GERMAN_CHARS,     # almost Kamenicky with ô replaced by ß
    }

def CharsetToCharMap(chars):
  """Returns map of Unicode characters to a given 8-bit charset."""
  assert len(chars) <= 42
  map = {}
  for i, char in enumerate(chars):
    map[char] = chr(128 + i).decode(PLACEHOLDER_CHARSET)
  # Ignore the Unicode BOM character.
  map[u'\ufeff'] = ''
  return map

def CharsetToOrdinalMap(chars):
  """Returns map of Unicode characters to a given 8-bit charset."""
  assert len(chars) <= 42
  map = {}
  for i, char in enumerate(chars):
    map[char] = 128 + i
  return map

def RecodeCharacterToUTF8(c, charset, ignore_error=False):
  if ord(c) < 128:
    return c
  else:
    try:
      # if outside the array, throw an exception
      return charset[ord(c) - 128]
    except IndexError as e:
      if ignore_error:
	return '?'
      else:
	raise e

def RecodeStringToUTF8(s, charset):
  try:
    return ''.join([RecodeCharacterToUTF8(c, charset) for c in s])
  except IndexError:
    print Exception('Cannot recode ' + s)
    return ''.join([RecodeCharacterToUTF8(c, charset, ignore_error=True)
                    for c in s])

def RecodeCharacterFromUTF8(c, charmap):
  if 32 <= ord(c) < 128 or c == '\r' or c == '\n':
    return c
  else:
    return charmap[c]
    # And throw an assert if not present.  In particular, reject tabs.

def RecodeStringFromUTF8(s, charmap):
  return ''.join([RecodeCharacterFromUTF8(c, charmap) for c in s])

def StripEOL(s):
  """Strips just the final \n but no other whitespace."""
  assert s[-1] == '\n'
  return s[:-1]
