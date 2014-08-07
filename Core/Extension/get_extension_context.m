function context = get_extension_context(ext, par, data)

% get_extension_context - get extension context
% ---------------------------------------------
%
% context = get_extension_context(ext, par, data)
%
% Input:
% ------
%  ext - extension to get context for
%  par - parent browser
%  data - browser state
%
% Output:
% -------
%  context - extension context

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

%---------------------
% HANDLE INPUT
%---------------------

%--
% get active browser if needed
%--

if nargin < 2
	par = get_active_browser;
end

%--
% get browser state if needed and possible
%--

if nargin < 3
	
	if ~isempty(par)
		data = get_browser(par);
	else
		data = [];
	end
	
end

%---------------------
% BUILD CONTEXT
%---------------------

%--
% basic context fields
%--

context.ext = ext; 

context.user = get_active_user;

context.library = get_active_library;

% NOTE: possibly a browser dependent field, however it fits better here

% NOTE: the meaning of the selected sound is not clear

if ~isempty(par)	
	context.sound = sound_update(data.browser.sound, data);
else
	context.sound = get_selected_sound;
end

%--
% parent browser fields
%--

if ~isempty(par)
	
	% NOTE: it seems like we could get a relevant library and user from parent
	
	context.par = par;

	%--
	% page
	%--
	
	context.page.start = data.browser.time;

	context.page.duration = data.browser.page.duration;

	context.page.channels = get_channels(data.browser.channels);
	
	%--
	% miscellaneous
	%--
	
	% NOTE: this is often useful in extension displays

	context.display.grid = data.browser.grid;

end
