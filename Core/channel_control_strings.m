function channel_control_strings(h,data)

% channel_control_strings - update channel control strings
% --------------------------------------------------------
%
% channel_control_strings(h,data)
%
% Input:
% ------
%  h - figure handle
%  data - figure userdata

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% the constraints based on the play channels should be reconsidered and
% removed, a simple rule can be devised to update the play channel to one
% of the remaining display channels

%--
% get channel control handles
%--

g = control_update(h,'Page','Channels');

if (~isempty(g))
	
	%--
	% create channel strings from channel matrix
	%--
	
	[L,value] = channel_strings(data.browser.channels);
	
	%--
	% update strings to contain play information
	%--
		
	% display of play channel information in the listbox control is not
	% consistent with the current approach of reassiging the play channels
	
% 	chp = data.browser.play.channel;
% 	
% 	if (~diff(chp))
% 		ix = find(data.browser.channels(:,1) == chp(1));
% 		L{ix} = [L{ix} '  (LR)'];
% 	else
% 		ix = find(data.browser.channels(:,1) == chp(1));
% 		L{ix} = [L{ix} '  (L)'];
% 		ix = find(data.browser.channels(:,1) == chp(2));
% 		L{ix} = [L{ix} '  (R)'];
% 	end
	
	%--
	% update strings and value of listbox control
	%--
		
	set(findobj(g,'style','listbox'), ...
		'string',L, ...
		'value',value ...
	);

	%--
	% disable cancel and apply buttons
	%--

	set(findobj(g,'style','pushbutton'),'enable','off');
	
end
