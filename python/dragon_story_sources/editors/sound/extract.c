/*
 * Extracting sound samples from cd.sam
 *
 * (c) 2006, Robert Spalek <robert@ucw.cz>
 */

#include <stdio.h>

unsigned char scream_header[80] = {
  /* Format:  Scream Tracker Sample sample mono 8bit unpacked
   * see http://www.wotsit.org/download.asp?f=s3i */
  0x01, 0x31, 0x00, 0x30, 0x30, 0x30, 0x00, 0x00,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00,
  0x01, 0x80, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0xf0, 0x55, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	0x00, 0x00, 0x00, 0x00, 0x53, 0x43, 0x52, 0x53
};

const int add_header = 1;

int
main(int argc, char **argv)
{
  if (argc < 3) {
    return 1;
  }
  FILE *ft = fopen(argv[1], "r");
  FILE *fi = fopen(argv[1], "r");
  if (!ft || !fi) {
    return 2;
  }
  int curr, next;
  fread(&curr, sizeof(int), 1, ft);
  printf("total length without header is %d, with header it is %d\n", curr, curr+32004);
  fread(&curr, sizeof(int), 1, ft);
  fseek(fi, curr, SEEK_SET);
  for (int i=1; i<8000; i++)
  {
    fread(&next, sizeof(int), 1, ft);
    if (!next)
      break;
    int len = next-curr;
    if (len < 0)
      len = 0;
    /* XXX: there is a bug at the end of cd.sam.  In particular, the last
     * length is -32004 instead of 0, because the size of the header is
     * mistakenly not taken into account.  */
    printf("%d: pos=%d, len=%d\n", i, curr, len);
    if (len)
    {
      char name[100];
      sprintf(name, "%s/%d.%s", argv[2], i, add_header ? "buf" : "raw");
      FILE *fo = fopen(name, "w");
      if (!fo) {
	return 3;
      }
      if (add_header)
      {
	* (int*) (scream_header + 16) = len;	// sample length
	// ignore setting filename in the header
	fwrite(scream_header, 80, 1, fo);
      }
      char data[len];
      fread(data, len, 1, fi);
      fwrite(data, len, 1, fo);
      fclose(fo);
    }
    curr = next;
  }
  fclose(ft);
  fclose(fi);
  return 0;
}

/* Raw format can be played under Linux as follows:
 *	play -r 22050 -s b -c 1 -f u -t raw -d /dev/dsp1 1.buf
 * that is:
 * 	- sampling frequency 22050 Hz
 * 	- 8-bit
 * 	- mono
 * 	- unsigned format
 * 	- raw audio file without a header
 *
 * You can convert the file to WAV (or anything else) as follows:
 *	sox -t raw -r 22050 -u -b -c 1 1.buf 1.wav
 *
 * You can compress it to MP3 with bitrate 32 kbps as follows:
 *	dd bs=1 skip=80 <1732.buf \
 *	| lame -s 22.05 --bitwidth 8 -m m --unsigned -r -b 32 - 1732-32.mp3
 *
 * The format used by msam.exe is S3I above with an 80 byte header
 */
