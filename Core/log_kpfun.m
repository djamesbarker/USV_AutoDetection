function log_kpfun(h)

% log_kpfun - key press function for log browser figure
% -----------------------------------------------------
%
% log_kpfun(h)
%
% Input:
% ------
%  h - handle of figure

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 513 $
% $Date: 2005-02-09 21:06:29 -0500 (Wed, 09 Feb 2005) $
%--------------------------------

% this function should contain information in the same way that the sound
% browser counterpart does

%--
% attach to figure
%--

if (nargin)
	set(h,'keypressfcn','log_kpfun;');
end

%--
% get current character
%--

n = double(get(gcf,'currentcharacter'));

%--
% escape empty characters
%--

if (isempty(n))
	return;
end

%--
% perform command
%--

switch (n)
	
%--------------------------------
% Play
%--------------------------------

%--
% Play Clip
%--

case (double('P'))
	
	log_sound_menu(gcf,'Play Clip');

%--
% Play Event
%--

case (double('p'))
	
	log_sound_menu(gcf,'Play Event');

%--
% Other Rate
%--

% this will be superseded by the opening of a palette

case (double('r'))
	
	log_sound_menu(gcf,'Other Rate ...');
	
%--------------------------------
% Navigate
%--------------------------------

%--
% View in Sound
%--

case (double('v'))
	
	event_menu(gcf,'View in Sound'); 
	
%--
% Previous View
%--

case (double('<'))
	
	log_view_menu(gcf,'Previous View');
	
%--
% Next View
%--

case (double('>'))
	
	log_view_menu(gcf,'Next View');
	
%--
% Previous Page (back arrow)
%--

case ({28,double('b')})
	
	log_view_menu(gcf,'Previous Page');
	
%--
% Next Page (forward arrow)
%--

case ({29,double('n')})
	
	log_view_menu(gcf,'Next Page');

%--
% First Page (up arrow)
%--

case (30)
	
	log_view_menu(gcf,'First Page');
	
%--
% Last Page (down arrow)
%--

case (31)
	
	log_view_menu(gcf,'Last Page');

%--
% Go To Page ...
%--

case (double('g'))
	
	log_view_menu(gcf,'Go To Page ...');

%--------------------------------
% Spectrogram
%--------------------------------

%--
% Difference Signal
%--

% this command is soon to be superseded by the filter extensions

case (double('d'))
	
	log_view_menu(gcf,'Difference Signal');
	
%--------------------------------
% Colormaps
%--------------------------------

%--
% Gray 
%--

case (double('G'))
	
	log_view_menu(gcf,'Gray ');

%--
% Hot
%--

case (double('H'))
	
	log_view_menu(gcf,'Hot');

%--
% Jet
%--

case (double('J'))
	
	log_view_menu(gcf,'Jet');

%--
% Bone
%--

case (double('B'))
	
	log_view_menu(gcf,'Bone');

%--
% HSV
%--

case (double('V'))
	
	log_view_menu(gcf,'HSV');
	
%--------------------------------
% Colormap Options
%--------------------------------

%--
% Colorbar
%--

case (double('c'))
	
	log_view_menu(gcf,'Colorbar');

%--
% Auto Scale
%--

case (double('a'))
	
	log_view_menu(gcf,'Auto Scale');

%--
% Invert
%--

case (double('i'))
	
	log_view_menu(gcf,'Invert');
	
%--------------------------------
% Selection 
%--------------------------------

%--
% Delete Selection (delete)
%--

case (127)
	
	log_edit_menu(gcf,'Delete Selection');
	
%--
% Selection Grid
%--

case (double(''''))
	
	log_view_menu(gcf,'Selection Grid');
	
%--
% Selection Labels
%--

case (double('"'))
	
	log_view_menu(gcf,'Selection Labels');
	
%--
% Control Points
%--

% editing should not happen in the clip viewer

case (double('.'))
	
	log_view_menu(gcf,'Control Points');

%--------------------------------
% Grid
%--------------------------------

%--
% Grid
%--

case (double(';'))
	
	log_view_menu(gcf,'Grid');
	
%--------------------------------
% Miscellaneous
%--------------------------------

%--
% Actual Size
%--

case (double('='))
	
	log_view_menu(gcf,'Actual Size');
	
%--
% Half Size
%--

case (double('-'))
	
	log_view_menu(gcf,'Half Size');

%--
% Refresh
%--

case (double('w'))
	
	log_resizefcn(gcf);
		
end
