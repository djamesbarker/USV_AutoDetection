function show_browser(h,str)

% show_browser - move to another browser
% --------------------------------------
%
% show_browser(h,str)
%
% Input:
% ------
%  h - browser figure handle
%  str - command 'first', 'previous', 'next', 'last'

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

% TODO: consider creating 'is_browser' function to test handles, possibly others

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set default command
%--

if ((nargin < 2) || isempty(str))
	str = 'next';
end

%--
% set default figure
%--

if (nargin < 1)
	h = gcf;
end

%-----------------------------------
% SHOW BROWSER
%-----------------------------------

%--
% get sound browser figure handles
%--

g = get_xbat_figs('type','sound');

% NOTE: return if there are no other browsers

if (length(g) < 2)
	return; 
end
			
%--
% sort handles by tag to determine order
%--

% NOTE: this could be confusing in the case of sounds from multiple libraries

tags = get(g,'tag');

[tags,ix] = sort(tags);  g = g(ix);

%--
% find position of current browser among open browsers
%--

if (~isempty(h))
	
	tag = get(h,'tag');

	ix = find(strcmp(tag,tags));

	% NOTE: return if we are not a browser

	if (isempty(ix))
		return;
	end 
	
end

%--
% select browser based on command string
%--

switch (str)
	
	case ('first')
		
		figure(g(1));
		
	case ('previous')

		if (ix > 1)
			figure(g(ix - 1));
		else
			figure(g(end));
		end

	case ('next')

		if (ix < length(g))
			figure(g(ix + 1));
		else
			figure(g(1));
		end
		
	case ('last')
		
		figure(g(end));

end
