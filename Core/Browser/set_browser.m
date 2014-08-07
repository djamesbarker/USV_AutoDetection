function [flag, failed] = set_browser(h, data, varargin)

% set_browser - set browser state
% -------------------------------
%
% [flag, failed] = set_browser(h, data, 'field', value, ... , 'field', value)
%
% Input:
% ------
%  h - browser figure
%  data - stored state
%  field - browser field name
%  value - browser field value
%
% Output:
% -------
%  flag - failure indicator
%  failed - failed fields

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
% $Date: 2005-08-25 10:08:48 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1670 $
%--------------------------------

% NOTE: this function provides uniform set to browser state and fields

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% return when there is nothing to set
%--

% TODO: change this to allow initial setting of full state

if length(varargin) < 1
	flag = 0; failed = []; return;
end

%--
% get browser state if needed
%--

if isempty(data)
	data = get_browser(h);
end

%--
% get field value pairs
%--

[field, value] = get_field_value(varargin);

%--
% be flexible about field names
%--

% NOTE: allow spaces instead of periods and be case insensitive

for k = 1:length(field)
	
	if any(field{k} == ' ')
		field{k} = lower(strrep(field{k}, ' ', '.'));
	end
	
end

%------------------------------------------
% SET BROWSER FIELD
%------------------------------------------

failed = cell(0);

for k = 1:length(field)

	switch field{k}

		%--
		% special fields
		%--

		% NOTE: special fields are stored in odd way

% 		case ('time'), value = set_slider_time(h); return;

		%--
		% stored fields
		%--

		otherwise

			[data.browser, flag] = set_field(data.browser, field{k}, value{k});

			% NOTE: failed will contain transformed field names
			
			if ~flag
				failed{end + 1} = field{k};
			end

	end

end

%------------------------------------------
% UPDATE BROWSER STATE
%------------------------------------------

set(h, 'userdata', data);

