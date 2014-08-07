function value = get_browser(par, field, data)

% get_browser - get browser state
% -------------------------------
%
%  data = get_browser(par)
%
% value = get_browser(par, field)
%
% Input:
% ------
%  par - browser handle
%  field - field name
%  data - stored state
%
% Output:
% -------
%  data - stored state
%  value - field value

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

% NOTE: this function provides uniform access to browser state and fields

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% set default parent
%--

if ~nargin || isempty(par)
	par = get_active_browser;
end

% NOTE: return if there is no parent available

if isempty(par) 
	value = []; return;
end

%--
% get browser data and return
%--

if (nargin < 2)
	value = get(par, 'userdata'); return;
end

%--
% be flexible about field names
%--

% NOTE: allow spaces instead of periods and be case insensitive

if any(field == ' ')
	field = lower(strrep(field, ' ', '.'));
end

%------------------------------------------
% GET BROWSER FIELD
%------------------------------------------

switch field

	%--
	% special fields
	%--

	% NOTE: special fields are computed or stored in odd way

	%--
	% stored fields
	%--

	otherwise

		% NOTE: get state store if needed

		if (nargin < 3)
			data = get_browser(par);
		end

		% NOTE: we could use default value safety, but we prefer failure
		
		value = get_field(data.browser, field);

end


