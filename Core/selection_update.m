function selection_update(par, data, sel)

% selection_update - update selection related display
% ---------------------------------------------------
%
% selection_update(par, data)
%
% Input:
% ------
%  par - browser figure handle
%  data - browser figure userdata

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
% $Revision: 819 $
% $Date: 2005-03-27 15:06:08 -0500 (Sun, 27 Mar 2005) $
%--------------------------------

%-------------------------------------------
% HANDLE INPUT
%-------------------------------------------

%--
% get userdata if needed
%--

if nargin < 2 || isempty(data)
	data = get(par, 'userdata');
end

if nargin < 3 || isempty(sel)
	sel = data.browser.selection;
end



%-------------------------------------------
% UPDATE SELECTION ZOOM DISPLAY
%-------------------------------------------

if ~sel.zoom
	
	%--
	% delete selection zoom figure if it exists 
	%--
	
	handle = get_xbat_figs( ...
		'parent', par, 'type', 'selection' ...
	);

	if ~isempty(handle)
		delete(handle);
	end
	
end

if isempty(sel.handle)
	
	% NOTE: if we add a close request function to this figure change to 'close'
	
	sel = get_xbat_figs( ...
		'parent', par, 'type', 'selection' ...
	);

	if ~isempty(sel)
		set(sel, ...
			'color', get(par, 'color'), ...
			'colormap', get(par, 'colormap') ...
		);
	end
	
	return;
	
end
	
%-------------------------------------------
% UPDATE SELECTION DISPLAY
%-------------------------------------------

%--
% pull out some browser fields
%--

sound = data.browser.sound;

page = data.browser.page; 

page.start = data.browser.time;

%--
% if there is no selection or it is out of page, return
%--

if isempty(sel.event) || ~event_in_page(sel.event, page, sound)
	return;
end

%--
% select new or logged selection
%--

if isempty(sel.event.id)

	browser_bdfun(sel.event);

else

	% NOTE: we try to get the log and event indices, to persist selection

	try
		
		if ~isempty(sel.log)

			ix = find(sel.event.id == [data.browser.log(sel.log).event.id]);

			if ~isempty(ix)
				event_bdfun(par, sel.log, ix);
			end

		end
		
	catch

		nice_catch(lasterror, 'NOTE: Failed to persist event selection.');

	end

end

	



