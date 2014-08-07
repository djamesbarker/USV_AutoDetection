function handles = update_selection_buttons(par, selection)

% update_selection_buttons - update selection buttons display
% -----------------------------------------------------------
%
% update_selection_buttons(par, selection)
%
% Input:
% ------
%  par - parent browser
%  selection - selection
%
% Output:
% -------
%  handles - updated buttons

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

%--
% get selection if needed
%--

if nargin < 2
	[selection, count] = get_browser_selection(par);
else
	if isstruct(selection)
		try
			count = length(selection.event);
		catch
			count = 0;
		end
	else
		count = selection
	end
end

%--
% get relevant figures and listeners
%--

par = [par, get_xbat_figs('parent', par)];

listener = {'BROWSER_ZOOM_SEL', 'sel_config'};

%--
% update buttons
%--

handles = [];

for k = 1:length(par)

	for j = 1:length(listener)

		handle = findobj(par(k), ...
			'type', 'uicontrol', ...
			'style', 'pushbutton', ...
			'tag', listener{j} ...
		);

		if isempty(handle)
			continue;
		end
		
		set(handle, ...
			'string', char(1), ...
			'fontname', 'Courier', ...
			'fontunits', 'pixels', ...
			'fontsize', 18 ...
		);

		if ~count
			set(handle, 'foregroundcolor', 0.5 * ones(1, 3));
		else
			set(handle, 'foregroundcolor', selection.color);
		end
		
		handles(end + 1) = handle;
		
	end

end
