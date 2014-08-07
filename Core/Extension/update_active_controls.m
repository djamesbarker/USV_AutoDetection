function pals = update_active_controls(par, type, active, data)

% update_active_controls - update palette active controls for extensions
% ----------------------------------------------------------------------
%
% pals = update_active_controls(par, type, active)
%
% Input:
% ------
%  par - parent browser
%  type - extension type
%  active - active extension names
%
% Output:
% -------
%  pals - open active extension palette handles

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

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% check browser and get state if needed
%--

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

if (nargin < 4) || isempty(data)
	data = get_browser(par);
end

%--
% check type and browser repository
%--

if ~ismember(type, get_extension_types)
	error(['Unrecognized extension type ''', type, '''.']);
end

if ~isfield(data.browser, type)
	return;
end

%-----------------------
% UPDATE PALETTES
%-----------------------

%--
% get extension names
%--

names = {data.browser.(type).ext.name};

%--
% turn off active controls in all palettes
%--

for k = 1:length(names)

	pal = get_palette(par, names{k}, data);

	if ~isempty(pal)
		set_control(pal, 'active', 'value', 0); set_active_toggle_menu(pal, 0);
	end
	
end

% NOTE: is there is no active input we are done

if (nargin < 2) || isempty(active)
	return;
end

%--
% turn on active control in active extension palettes
%--

if ischar(active)
	active = {active};
end

if ~iscellstr(active)
	error('Active input must be a string of cell array of strings.');
end

pals = [];

for k = 1:numel(active)

	pal = get_palette(par, active{k}, data);

	if ~isempty(pal)
		pals(end + 1) = pal; set_control(pal, 'active', 'value', 1); 
		set_active_toggle_menu(pal, 1);
	end

end
	

