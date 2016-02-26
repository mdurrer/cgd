#!/bin/bash
#
# Compares the game scripts in 2 different languages
set -e

STRING_DIR=$1
L1=$2
L2=$3

mkdir -p ../game-scripts/$L2-translated-from-$L1

if false
then
  # Recode using UTF-8 strings
  ./fix-translation.py \
      -i../game-scripts/$L1 \
      -u../game-scripts/$L2-translated-from-$L1 \
      -t \
      -o $STRING_DIR/utf-8/retezce-$L1.txt \
      -e $STRING_DIR/utf-8/retezce-$L2.txt
else
  # Recode using 8-bit-charset strings
  ./fix-translation.py \
      -i../game-scripts/$L1 \
      -u../game-scripts/$L2-translated-from-$L1 \
      -t \
      -o $STRING_DIR/recoded/retezce-$L1.txt \
      -e $STRING_DIR/recoded/retezce-$L2.txt \
      -O $L1 \
      -E $L2
fi

if false
then
  ./fix-titles.py \
      -i../game-scripts/$L2-translated-from-$L1 \
      -u../game-scripts/$L2-translated-from-$L1

  mkdir -p ../game-scripts/$L2-without-titles
  ./fix-titles.py \
      -i../game-scripts/$L2 \
      -u../game-scripts/$L2-without-titles
  SECOND_DIR=$L2-without-titles
else
  ./fix-titles.py \
      -i../game-scripts/$L2-translated-from-$L1 \
      -u../game-scripts/$L2-translated-from-$L1 \
      -t../game-scripts/$L2

  SECOND_DIR=$L2
fi

diff -rwU5 \
    ../game-scripts/$L2-translated-from-$L1 \
    ../game-scripts/$SECOND_DIR \
| less
