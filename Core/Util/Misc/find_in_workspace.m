function var = find_in_workspace(x, workspace)

% find_in_workspace - find variable in specified workspace
% --------------------------------------------------------
%
% var = find_in_workspace(x, workspace)
%
% Input:
% ------
%  x - variable
%  workspace - workspace to search (def: 'base')
%
% Output:
% -------
%  var - variable structure output from 'whos'

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


if nargin < 2 || isempty(workspace)
	workspace = 'base';
end

var = [];

vars = evalin(workspace, 'whos');

for k = 1:length(vars)

	if ~isequal(size(x), vars(k).size) || ~isequal(x, evalin(workspace, vars(k).name))
		continue
	end

	var = vars(k); 

end
