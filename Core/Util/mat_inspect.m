function [var,file] = mat_inspect(in,varargin)

% mat_inspect - get variable and file info for MAT file
% -----------------------------------------------------
%
% [var,file] = mat_inspect(in,'var_1', ... ,'var_n')
%
% Input:
% ------
%  in - file location
%  var_k - variable name description
%
% Output:
% -------
%  var - variable content info
%  file - file info

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
% $Revision: 2196 $
% $Date: 2005-12-02 18:16:46 -0500 (Fri, 02 Dec 2005) $
%--------------------------------

%--
% get variable content information
%--

var = []; 

names = varargin;

if (length(names))
	
	%--
	% check input names are strings
	%--
	
	if (~iscellstr(names))
		error('Variable name descriptions must be strings.');
	end
	
	%--
	% get variable info through variable names
	%--
	
	temp = whos('-file',in,names{:});
			
	%--
	% return variable info structure
	%--
	
	% NOTE: empty info means the variable was not found

	found = {temp.name};

	for k = 1:length(names)

		if (~isvarname(names{k}))
			disp(['WARNING: ''' names{k} ''', is not a valid variable name.']); continue;
		end

		ix = find(strcmp(found,names{k}));

		if (isempty(ix))
			var.(names{k}) = [];
		else
			var.(names{k}) = temp(ix);
		end

	end
				
else
	
	%--
	% get all variable information
	%--
	
	temp = whos('-file',in);

	%--
	% return variable info structure
	%--

	found = {temp.name};

	for k = 1:length(found)
		var.(found{k}) = temp(k);
	end
	
end

%--
% get file information if needed
%--

if (nargout > 1)
	file = dir(in);
end
