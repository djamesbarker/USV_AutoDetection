function  edit = selection_edit_update(h,data)

% selection_edit_update - update selection edit state array upon edit
% -------------------------------------------------------------------
%
% edit = selection_edit_update(h,data)
% 
% Input:
% ------
%  h - handle to figure
%  data - figure userdata (not changed)
%
% Output:
% -------
%  edit - updated edit state array

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

%--
% get edit state array from data
%--

edit = data.browser.edit;

%--
% collect edit state variables
%--

state.time = data.browser.time;

state.page = data.browser.page;

state.channels = data.browser.channels;

state.play.channel = data.browser.play.channel;

state.specgram = data.browser.specgram;

%--
% update the edit state
%--

pre = edit.length - edit.position;

%--
% the edit is the last edit, append to edit array
%--

if (pre == 0)
	
	%--
	% check that we have not exceeded the maximum edit length
	%--
	
	if (edit.length < edit.max)
		
		tmp = edit.position + 1;
		
		edit.state(tmp) = state;
		edit.position = tmp;
		edit.length = tmp;
		
	else
		
		edit.state(1:(end - 1)) = edit.state(2:end);
		edit.state(end) = state;
		
	end
	
%--
% the edit is not the last edit, fold the previous edit edits 
%--

else
	
	%--
	% fold next edits into past checking
	%--
	
	pos = edit.position;
	edit.state = [edit.state(1:edit.length), fliplr(edit.state(pos:(pos + pre - 1))), state];
	tmp = length(edit.state);
	edit.position = tmp;
	edit.length = tmp;
	
	%--
	% truncate edits array to maximum length
	%--
	
	if (length(edit.state) > edit.max)
		tmp = edit.max;
		edit.state = edit.state((end - tmp + 1):end);
		edit.position = tmp;
		edit.length = tmp;
	end
	
end

%--
% update state of edit navigation menus
%--

set(get_menu(h,'Next View',2),'enable','off'); 
set(get_menu(h,'Previous View',2),'enable','on');
