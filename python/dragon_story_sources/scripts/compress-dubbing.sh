#!/bin/bash
#
# Recodes the dubbing of Dragon History into an uncompressed ZIP archive of MP3
# files, resp. FLAC files.
set -e

COMPRESSION_TYPE=$1
BUF_PATH=$2
DEST_PATH=$3

MP3_PATH=$DEST_PATH/dubbing-mp3
FLAC_PATH=$DEST_PATH/dubbing-flac
OGG_PATH=$DEST_PATH/dubbing-ogg

case $COMPRESSION_TYPE in
mp3)
  # Constant bit-rate MP3 (32kbps)
  cd "$BUF_PATH"
  mkdir -p $MP3_PATH
  for buf_file in [0-9]*.buf
  do
    mp3_file="$MP3_PATH/${buf_file%.buf}.mp3"
    echo "Recoding $buf_file to $mp3_file"
    dd bs=1 skip=80 <$buf_file 2>/dev/null \
      | lame -s 22.05 --bitwidth 8 -m m --unsigned -r -b 32 - "$mp3_file" \
      2>/dev/null
  done
  cd "$MP3_PATH"
  zip -0 ../dub-mp3.zzz *.mp3
  ;;

flac)
  # FLAC at the highest compression level
  cd "$BUF_PATH"
  mkdir -p $FLAC_PATH
  for buf_file in [0-9]*.buf
  do
    flac_file="$FLAC_PATH/${buf_file%.buf}.flac"
    echo "Recoding $buf_file to $flac_file"
    dd bs=1 skip=80 <$buf_file 2>/dev/null \
      | flac --endian=little --channels=1 --bps=8 --sample-rate=22050 \
	--sign=unsigned -8 -f -o $flac_file - \
      2>/dev/null
  done
  cd "$FLAC_PATH"
  zip -0 ../dub-flac.zzz *.flac
  ;;

ogg)
  # Average bit-rate OGG (24kbps requested, but it's typically more than 32kbps)
  cd "$BUF_PATH"
  mkdir -p $OGG_PATH
  for buf_file in [0-9]*.buf
  do
    ogg_file="$OGG_PATH/${buf_file%.buf}.ogg"
    echo "Recoding $buf_file to $ogg_file"
    dd bs=1 skip=80 <$buf_file 2>/dev/null \
      | oggenc -r -B 8 -C 1 -R 22050 -b 24 -Q -o $ogg_file -
  done
  cd "$OGG_PATH"
  zip -0 ../dub-ogg.zzz *.ogg
  ;;

raw)
  # Make a normal ZIP archive as well
  cd "$BUF_PATH"
  zip -9 $DEST_PATH/dub-raw.zzz *.buf
  ;;

*)
  echo Unsupported compression type [$COMPRESSION_TYPE]
  ;;
esac
