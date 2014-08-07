function par = browser_zoom(type, par)

% browser_zoom - zoom browser page
% --------------------------------
%
% par = browser_zoom('in', par), zoom in
%
%     = browser_zoom('out', par), zoom out
%
%     = browser_zoom('sel', par), zoom to selection
%
% Output:
% -------
%  par - updated browser

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

%---------------
% HANDLE INPUT
%---------------

%--
% get active browser if needed
%--

if nargin < 2
	par = get_active_browser;
end

%--
% check browser input
%--

if ~is_browser(par)
	return;
end

%---------------
% SETUP
%---------------

data = get_browser(par);

page = data.browser.page;

sel = data.browser.selection;

%---------------
% ZOOM
%---------------

switch type
	
	case 'in'
		
		set_browser_page(par, 'slider', ...
			'time', data.browser.time + page.duration / 4, ...
			'duration', page.duration / 2 ...
		);
		
	case 'out'
		
		set_browser_page(par, 'slider', ...
			'time', data.browser.time - page.duration / 2, ...
			'duration', page.duration * 2 ...
		);
		
	case 'sel'
		
		if isempty(sel.event)
			return;
		end

		pad = sel.event.duration / 20;
		
		set_browser_page(par, 'slider', ...
			'time', sel.event.time(1) - pad, ...
			'duration', sel.event.duration + 2 * pad ...
		);
		
	otherwise

		error('Unrecognized zoom command.');
		
end
