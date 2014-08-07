function active = get_active_filters(par, data)

% get_active_filters - get currently active filters
% -------------------------------------------------
%
% active = get_active_filters(par, data)
%
% Input:
% ------
%  par - parent browser
%  data - browser data
%
% Output:
% -------
%  active - filter extensions and context

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
% check browser input
%--

if ~is_browser(par)
	error('Input handle is not browser handle.'); 
end

%--
% get browser userdata
%--

if (nargin < 2) || isempty(data)
	data = get_browser(par); 
end

%--
% get active filters
%--

% NOTE: filters may be many, but context will be one, a consequence of 'get_active_extension'

[active.signal_filter, ignore, active.signal_context] = get_active_extension('signal_filter', par, data);

[active.image_filter, ignore, active.image_context] = get_active_extension('image_filter', par, data);


