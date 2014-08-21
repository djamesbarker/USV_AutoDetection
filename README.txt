Source code for the Detection of Ultrasonic Vocalizations (USVs) in XBAT:
-----------------------------------------------------------------------------
XBAT is the intellectual product of Cornell University, as described below.
Code related to the detection of ultrasonic vocalizations was developed by
Dr. David J. Barker and Christopher Hererra at Rutgers University under the 
direction of Dr. Mark O. West. 

In this version, these files have been integrated into the XBAT open-source
software in the Extensions\Detectors and Extensions\Actions directories.
As with XBAT, these files are open source and intended for free public use.

Details regarding the development of the detector can be found within our published
work:

Barker DJ, Herrera C, West MO (In Press). Automated Detection of 50-kHz Ultrasonic 
Vocalizations Using Template Matching in XBAT. Journal of Neuroscience Methods.

We are currently in the process of developing other documentation in order to help
new users become familiar with the software.  Please check back for updates.

Also visit www.rci.rutgers.edu/~markwest/ for updates.



XBAT PREVIEW (REVISION 7)
-------------------------
01-Nov-2006

ABOUT
-----
XBAT is an extensible sound analysis application and 
MATLAB platform for developing sound analysis tools. 
It is open-source, licensed under the GPL. 

For more information about XBAT and any of the following
topics visit the project website - http://xbat.org

REQUIREMENTS
------------
This preview release has been developed and tested 
on Windows XP with MATLAB 7 and later. We plan 
eventually to support other platforms for which MATLAB 
is available.

XBAT makes extensive use of MATLAB MEX extensions. 
This release does not include precompiled binaries of 
MEX extensions for platforms other than Windows. The 
source is there, for the more adventurous, and we 
are available for help.

We currently rely on the signal-processing toolbox 
for a number of the signal filtering extensions. Overall, 
we have tried to reduce dependencies, in particular for the 
XBAT Core which depends solely on MATLAB. 

GETTING STARTED
---------------
Installing and getting started with XBAT is easy. 
If you downloaded the latest stable release from the 
XBAT website, you need only to:

1. Unzip the XBAT .zip file into a directory (folder)
   of your choosing 

2. Start MATLAB.

3. Set your working directory to the folder you 
   unzipped XBAT to.

4. Run xbat.m by typing 'xbat' on the command-line.

(If you are using Subversion to get the latest 
development version, the only difference is step 1, 
you have no need to unzip.)

On running the command 'xbat' you will see a splash
screen that animates and tells you something about the 
startup process and then the 'XBAT' palette will open up 
when startup is done.

The MATLAB path will be modified to contain all the 
required directories, and non-toolbox elements of the 
path will be moved to the end of the path to make sure 
XBAT works properly, if this happens a warning will 
be issued.

FIRST STEPS, LEARNING, AND GETTING HELP
---------------------------------------
After startup the 'XBAT' palette becomes the initial
focus of attention. You can make sounds available to 
XBAT by adding them to a library. 

You can add a single sound file using the 'Add File ...'
button in the 'Sounds' panel. You can add a directory 
of sounds, including all its children, using the 
'Add Folder ...' button. 

XBAT treats directories containing a collection of 
'compatible' sound files (same channels, samplerate,
and format) as a single sound, the files are 
ordered alphabetically.

The added sounds show up in the 'Sounds' list display. 
You can open a sound from this list by double-clicking it 
on the list, or by using the 'Open ...' command in the 
right-click triggered context-menu.

The sound browser is a typical focus of attention when 
working with XBAT. Exploration is your best strategy in 
learning to use the sound browser. Don't worry about your 
files, XBAT does not modify sound files in any way. To 
explore the capabilities of the sound browser look around
the various menus. 

Through the menus you can then open then open various 
control palettes. Browser related control palettes are
available from the 'Window' menu in the browser. 
Palettes controlling various extensions are available 
from the 'Filter' and 'Detect' menus.


As before, more information about XBAT please visit the 
project website - http://xbat.org
