function info = get_browser_info(par)

% get_browser_info - get basic browser info
% -----------------------------------------
%
% info = get_browser_info(par)
%
% Input:
% ------
%  par - browser handle
%
% Output:
% -------
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
% $Revision: 2093 $
% $Date: 2005-11-08 16:46:14 -0500 (Tue, 08 Nov 2005) $
%--------------------------------

% TODO: create 'set_browser_info' to store browser info?

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% check handle input
%--

if any(~ishandle(par))
	error('Handle input is required.');
end

%--
% check figure handles
%--

if any(~strcmp(get(par, 'type'), 'figure'))
	error('Input handles must be figure handles.');
end

%--
% handle arrays recursively
%--

if (numel(par) > 1)
	
	for k = 1:numel(par)
		info(k) = get_browser_info(par(k));
	end
	
	info = reshape(info, size(par)); return;
	
end

%------------------------------
% GET BROWSER INFO
%------------------------------

info = parse_browser_tag(get(par, 'tag'));
