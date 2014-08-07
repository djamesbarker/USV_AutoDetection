Important note: 
This version of iTunesEncode *requires* iTunes 4.6 or above, but iTunes 4.7 or above is recommended.


Usage: iTunesEncode.exe [options] -i <input.wav> [-o <output.m4a>]

  Tagging Options:
  -a <Artist>      Adds an artist tag to the file
  -l <Album>       Adds an album tag to the file
  -t <Title>       Adds a song title tag to the file
  -g <Genre>       Adds a genre tag to the file
  -y <Year>        Adds a year tag to the file
  -n <TrackNum>    Adds a track number tag to the file
  -m <TrackCount>  Adds a track count tag to the file
  -b <BPM>         Adds a BPM tag to the file
  -c <Comment>     Adds a comment tag to the file
  -u <Grouping>    Adds a grouping tag to the file
  -x <Compilation> Adds a compilation tag to the file
  -p <Composer>    Adds a composer tag to the file
  -j <DiscNumber>  Adds a disc number tag to the file
  -k <DiscCount>   Adds a disc count tag to the file
  -r <filename>    Adds artwork to the file

Tag option notes:
-Options y,n,m,b,e,f should be numeric.
-Option x is a boolean and can be 1,true,yes,T,Y,on,enable...

  Non-tagging options:
  -i <filename>    Specifies the input file. The input file can be
                   of any format iTunes can read.
                   (WAV, AIFF, M4A, MP3, WMA)

  -o <filename>    Specifies an output file. The resulting encoded
                   file will be copied here after encoding and
                   tagging are complete.

  -s <delay>       Delay to use in milliseconds (default: 4000).
                   Increase this if you experience problems
                   using iTunesEncode on long batch encodes.

  -e EncoderName   Lets you specify the encoder iTunes will use.
                   Choose from "AAC Encoder", "WAV Encoder",
                   "MP3 Encoder", "AIFF Encoder",
                   or "Lossless Encoder".
                   (Default is "AAC Encoder".)

  -d   This switch will make the program delete the song from
       the iTunes library once encoding and copying are complete.

Non-tag option notes:
-If you don't have an output specified, then the output
 won't be copied anywhere, and so using -d would be a bad idea.

-If the output file exists, it will be overwritten.




Suggested EAC Config string:
-e "AAC Encoder" -a "%a" -l "%g" -t "%t" -g "%m" -y %y -n %n -i %s -o %d

Suggested Foobar 2000 clienc config string (may need changes depending on your setup):
-e "AAC Encoder" -a "%artist%" -l "%album%" -t "%title%" -g "%genre%" -y %date% -n %tracknumber% -i %s -o %d

Suggested CDEx config string:
-e "AAC Encoder" -a "%a" -l "%b" -t "%t" -g "%g" -y "%y" -n "%tn" -c "iTunes AAC Encoder" -i %1 -o %2 -d

Suggested AudioGrabber config string:
-e "AAC Encoder" -a "%1" -l "%2" -t "%4" -g "%7" -y "%6" -n "%3" -i %s -o %d




Extra notes:

Note regarding the output file:
You may have noticed that the output file is optional. When iTunes converts a file, it adds the new file to its own library. This means a copy of the file exists in whatever location the iTunes library is. If you don't specify an output file, then all this is doing is leaving it wherever iTunes puts it. If you do specify an output file, then what's actually happening is that this program asks iTunes where that converted file is and then copies it to your output file. So there will be two copies of the file then. You can use the -d option to tell iTunes to delete the first copy and its library entry, if you like.


Note regarding the output file 2: 
If you specify and output file, and the output file exists, it will be overwritten.


Note regarding use of the -d option:
If you don't have an output specified, then the output won't be copied anywhere, and so using -d would be a bad idea. Because what would happen would be that it would encode the file, not copy it anywhere, and tell iTunes to delete it. Not particularly useful, I feel. :)


Note regarding options:
Any options above with spaces in them need to be surrounded by quotation marks. If they don't have spaces, they don't need quotation marks. Like this example:

iTunesEncode.exe -a "Artist Name" -t "Song Title" -l Album -y 2004 -i input.wav -o output.m4a


Note regarding options 2:
The options, including -i and -o and such, can be in any order.


Note regarding the input file:
The input file type can be any file type that iTunes can read. This includes WAV's, MP3's, M4A's, probably even unprotected WMA files.





End of notes. :)



Legal mumbo-jumbo:

 * Copyright (c) 2004 Samuel Wood (sam.wood@gmail.com)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
