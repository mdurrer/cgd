#!/usr/bin/python
# 
# Strings Builder for Draci Historie
#
# usage:
#		run this script from the same directory as the
#		RETEZCE.TXT file (which was created with draci_strings_extract.py)
#		It will build a RETEZCE.DFW.NEW file that can then be used
#		with Draci Historie in ScummVM. 
#		This script appends a .NEW extension to the generated file just in
#		case it has been run from the Draci Historie location, and doen't
#		assume that you want to overwrite the original.
#
from struct import pack, unpack
from os     import path
import getopt
import sys

# Target archive with the Draci Historie text strings
BASE_FILENAME = "RETEZCE.TXT"
DUMP_FILENAME = "RETEZCE.DFW.NEW"

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

# Return the given value as numeric
def read(target):	
	return unpack("B", target)[0]

# Read a byte off the filestream if no target specified. If a target
# is given, interpret it as a numeric value
def w(target):	
	return pack("B", target)[0]

# Read 2-bytes (little-endian) off the filestream
def w16(target):	
	return pack("<H", target)

# Read 4-bytes (little-endian) off the filestream
def w32(target):	
	return pack("<L", target)

# Generate a simple CRC value
def generate_crc(data):
	crc = 0
	for i in range(0, len(data)):
		crc ^= read(data[i])
	return crc

# Ensure that the file is in the same location as the
# strings builder script
if not path.exists(BASE_FILENAME):
		print BASE_FILENAME + " not found"
		sys.exit(1)

print "Found file [" + BASE_FILENAME + "]"

infile  = open(BASE_FILENAME, "r")
entries = []

# Read each line into an array
for line in infile:
	entries.append(line)
infile.close()

outfile = open(DUMP_FILENAME, "wb")
outfile.write("BAR!")
outfile.write(w16(len(entries)))
outfile.write(w32(0)) # Placeholder for footer location

offsets = []

for entry in entries:	
	entry = entry[0:len(entry) - 1] # Remove the line break
	entry += "|"                    # Each entry is terminated by a pipe
	length = len(entry)
	entry = w(length) + entry
	comp_len = length + 7
	outfile.write(w16(comp_len))   # Compressed Length
	outfile.write(w16(length + 1)) # Entry Length
	outfile.write(w(0))            # Compression Type (always zero)
	crc = generate_crc(entry)
	outfile.write(w(crc))	
	outfile.write(entry)
	
	offsets.append(comp_len)

pos = 10
for offset in offsets:	
	outfile.write(w32(pos))
	pos += offset	

outfile.write(w32(pos)) # Final entry is footer location
outfile.seek(6)
outfile.write(w32(pos)) # Write foother location in header

print "Built strings file [" + DUMP_FILENAME + "]"
	
outfile.close()

