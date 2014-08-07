function others = get_others(in, visible)

% get_others - get other handles with same parent
% -----------------------------------------------
%
% others = get_others(in, visible)
%
% Input:
% ------
%  in - handle
%  visible - consider visibility
%
% Output:
% -------
%  others - handles for same type objects with same parent

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

% TODO: this function was extracted from 'get_play_axes' it is not yet general

%--
% set default visible flag
%--

if (nargin < 2) || isempty(visible)
	visible = 1;
end

%--
% get other objects of same type possibly requiring visibility
%--

par = get(in, 'parent'); type = get(in, 'type');

if visible
	all = findobj(par, 'type', type, 'visible', 'on');
else
	all = findobj(par, 'type', type);
end

% HACK: this removes colorbar axes from other consideration, these were causing 'is_top' to fail

all = setdiff(all, findobj(par, 'tag', 'Colorbar'));

% HACK: remove things that are not channel tagged

tags = get(all, 'tag');

if ischar(tags)
	tags = {tags};
end

warning('off','MATLAB:dispatcher:InexactMatch');

for k = length(tags):-1:1
	
	% NOTE: currently channel tags are integer strings, this implies we can evaluate tag
	
	% NOTE: this is a neccesary but not sufficient condition, hence the HACK
	
	try
		value = eval([tags{k}, '.']);
	catch
		all(k) = []; continue;
	end
	
	if isempty(value) || ischar(value)
		all(k) = [];
	end
	
end

warning('on','MATLAB:dispatcher:InexactMatch');

%--
% remove self from list
%--

others = setdiff(all, in);
