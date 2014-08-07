function value = has_presets(ext)

% has_presets - test whether extension may have presets
% -----------------------------------------------------
%
% value = has_presets(ext)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  value - result of test 

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
% get potential preset types
%--

types = get_preset_types(ext);

%--
% check whether there are any implemented preset types
%--

% NOTE: implemented means extension has controllable parameters of a type

value = [];

for k = 1:length(types)
	
	type = types{k};
	
	% NOTE: there are no tests on whether these functions actually work, this could be done
	
	if isempty(type)
		value(end + 1) = ~isempty(ext.fun.parameter.create) && ~isempty(ext.fun.parameter.control.create);
	else
		value(end + 1) = ~isempty(ext.fun.(type).parameter.create) && ~isempty(ext.fun.(type).parameter.control.create);
	end
	
end

value = any(value);
