#!/usr/bin/python
# 
# Strings Extractor for Draci Historie
#
# usage:
#		run this script from the same directory as the
#		RETEZCE.DFW file. It will create a RETEZCE.TXT file
#		that can be edited in any text editor
#
from struct import *
from os import path
import getopt
import sys

# Target archive with the Draci Historie text strings
BASE_FILENAME = "RETEZCE.DFW"
DUMP_FILENAME = "RETEZCE.TXT"

try:
  opts, args = getopt.getopt(
      sys.argv[1:],
      'i:o:',
      ['input=', 'output='])
except getopt.GetoptError, err:
  print str(err)
  sys.exit(2)
for o, a in opts:
  if o in ('-i', '--input'):
    BASE_FILENAME = a
  if o in ('-o', '--output'):
    DUMP_FILENAME = a

# Read a byte off the filestream if no target specified. If a target
# is given, interpret it as a numeric value
def read(target = None):
	value = target if target != None else infile.read(1)
	return unpack("B", value)[0]

# Read 2-bytes (little-endian) off the filestream
def read16():
	value = infile.read(2)
	return unpack("<H", value)[0]

# Read 4-bytes (little-endian) off the filestream
def read32():
	value = infile.read(4)
	return unpack("<L", value)[0]	


# Ensure that the file is in the same location as the
# text extraction script
if not path.exists(BASE_FILENAME):
		print BASE_FILENAME + " not found"
		sys.exit(1)

print "Found file [" + BASE_FILENAME + "]"
infile = open(BASE_FILENAME, "r")

# Read in the archive and record information
header        = infile.read(4)
entries       = read16()
footer_offset = read32()

infile.seek(footer_offset)
offsets = []

for i in range(0,entries):
	offsets.append(read32())

outfile = open(DUMP_FILENAME, "wb")

for j in range(0, entries):
	infile.seek(offsets[j])
	comp_len   = read16() # string length + header size (6)
	length     = read16() # string length
	comp_type  = read()   # always zero
	data_crc   = read()
	
	# XXX The final byte seems to indicate string length, but isn't
	# used directly (though it could be)
	#string_len = read()
	
	# Read the string in, but ignore the final character, as it's
	# always a pipe
	data = infile.read(length)		
	crc = 0
	
	for k in range(0, length):
		crc ^= read(data[k])
	
	if crc != data_crc:
		print "CRC Mismatch for entry #" + j
		infile.close()
		sys.exit(3)
	
	# Note that our output needs to make the following adjustments
	#  (a) start from start + 1 as that byte, which contains the length 
	#      of the string, is unused when extracting the string, but is 
	#      used for CRC calculation
	#  (b) drop the last character, which is always a pipe (|)
	#  (c) add a line break to the end of each record
	outfile.write(data[1:len(data)-1] + "\n")

print "Dumped strings to [" + DUMP_FILENAME + "]"

outfile.close()
infile.close()
