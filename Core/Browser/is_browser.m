function [value, info] = is_browser(par)

% is_browser - check browser handles
% ----------------------------------
%
% [value, info] = is_browser(par)
%
% Input:
% ------
%  par - proposed browser handles
%
% Output:
% -------
%  value - browser indicator
%  info - browser info

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

% TODO: make this leaner for the simple most common case, like 'is_palette'

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% handle multiple handles recursively
%--

if numel(par) > 1
	
	value = zeros(size(par)); 
	
	if iscell(par)
		
		for k = 1:numel(par);
			value(k) = is_browser(par{k});
		end
		
	else
		
		for k = 1:numel(par);
			value(k) = is_browser(par(k));
		end
		
	end
	
	return;
	
end

%--
% check for figure handles
%--

if ~is_handles(par, 'figure')
	value = 0; info = []; return;
end

%--------------------------------
% TEST HANDLE
%--------------------------------

%--
% get browser info and check type
%--

info = get_browser_info(par);

value = ~isempty(strfind(upper(info.type), 'BROWSER'));
