function value = is_taggable(in)

% is_taggable - check that input is taggable
% ------------------------------------------
%
% value = is_taggable(in)
%
% Input:
% ------
%  in - object to tag
%
% Output:
% -------
%  value - taggable object test result

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
% strucures with a tags field are taggable
%--

value = 0;

if ~isstruct(in)
	return;
end

if isfield(in, 'tags')
	value = 1; return;
end

% NOTE: the following code is a future reminder, it is not currently used

return;

%--
% we can read tags if we pass this test
%--

% TODO: consider whether we can write tags

if ~isfield(in, 'type')
	value = 0; return;
end

type = in.type; accesors = {[type, '_tags'], ['get_', type, '_tags']}

for accessor = accesors
	
	info = functions(str2func(accessor));
	
	if ~isempty(info.file)
		value = 1; return;
	end
	
end

value = 0;
