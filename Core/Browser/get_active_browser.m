function par = get_active_browser

% get_active_browser - get handle to current browser
% --------------------------------------------------
%
% par = get_active_browser
%
% Output:
% -------
%  par - active browser handle

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

persistent LAST_BROWSER

%--
% get browser handles
%--

par = get_xbat_figs('type', 'sound'); 

%--
% no browser or a single browser
%--

if isempty(par) || (numel(par) == 1)
	return;
end

%--
% return single visible browser
%--

visible = get(par, 'visible');

ix = find(strcmp(visible, 'on'));

if numel(ix) == 1
	par = par(ix); LAST_BROWSER = par; return;
end

%--
% browser is current figure
%--

current = gcf;

if ismember(current, par)
	par = current; LAST_BROWSER = par; return;
end

%--
% return browser parent of palette
%--

if is_palette(current)
	
	current = get_palette_parent(current);
	
	if ismember(current, par)
		par = current; LAST_BROWSER = par; return;
	end
	
end

if ~isempty(LAST_BROWSER) && is_browser(LAST_BROWSER)
    par = LAST_BROWSER; return;
end

% NOTE: return empty if all of the above failed

par = [];

