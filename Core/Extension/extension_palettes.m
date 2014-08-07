function pal = extension_palettes(par, name, type)

% extension_palettes - open an extension palette
% ----------------------------------------------
%
% pal = extension_palettes(par, name, type)
%
% Input:
% ------
%  par - parent browser
%  name - extension name
%  type - extension type
%
% Output:
% -------
%  pal - palette

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

%-------------------
% HANDLE INPUT
%-------------------

%--
% initialize output get types
%--

pal = []; types = get_extension_types;

%--
% try to get extension type from name
%--

if (nargin < 3) || isempty(type)

	%--
	% get all possible types
	%--
	
	type = {};

	for j = 1:length(types)

		if ~isempty(get_extensions(types{j}, 'name', name))
			type{end + 1} = types{j};
		end

	end

	if isempty(type)
		return;
	end
	
	% TODO: produce some kind of warning
	
	if length(type) > 1
		return;
	end 
	
	% NOTE: unpack type to string
	
	type = type{1};
	
end

% NOTE: return empty on failure to find matching extension

if ~ismember(type, types)
	error(['Unrecognized extension type ''', type, '''.']);
end

%--
% open extension palette
%--

switch type

	% TODO: annotations, measures

	case {'signal_filter', 'image_filter'}

		pal = browser_filter_menu(par, [name, ' ...'], type);

	case 'sound_detector'

		pal = browser_detect_menu(par, [name, ' ...']);
		
	case 'sound_feature'
		
		pal = browser_feature_menu(par, [name, ' ...']);

end
