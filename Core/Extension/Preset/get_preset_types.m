function types = get_preset_types(ext)

% get_preset_types - get preset types for extension
% -------------------------------------------------
%
% types = get_preset_types(ext)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  types - preset types

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

% NOTE: we assume all parameters have presets

%--
% get function names
%--

fun = fieldnames(flatten_struct(ext.fun)); 

%--
% get preset types from function names
%--

% NOTE: don't we need controls in order to have presets?

types = cell(0);

for k = 1:numel(fun)
	
	%--
	% check for parameter create type method
	%--
	
	ix1 = strfind(fun{k}, 'parameter__create');
	
	if isempty(ix1)
		continue;
	end
	
	% NOTE: we expect the match to be unique
	
	if (ix1 == 1)
		types{end + 1} = ''; continue;
	end
	
	ix2 = strfind(fun{k}, '_');
	
	% NOTE: this code has not been tested
	
	for j = numel(ix2):-1:1
		if (ix2(j) < ix1 - 2)
			types{end + 1} = fun{k}(ix2(j) + 1:ix1 - 3); continue;
		end
	end
	
	types{end + 1} = fun{k}(1:ix1 - 3);

end
