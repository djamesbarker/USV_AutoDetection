function out = which_mem(ignore)

% which_mem - get full location of functions in memory
% ----------------------------------------------------
% 
% out = which_mem(ignore)
%
%
% Input:
% ------
%  ignore - set paths to ignore in listing
%
% Output:
% ------
%  out - path location strings for called functions

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
% $Revision: 385 $
% $Date: 2005-01-14 19:10:10 -0500 (Fri, 14 Jan 2005) $
%--------------------------------

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

%--
% set paths to ignore
%--

if (~nargin)
	
	% NOTE: this ignores functions already in the XBAT root and basic matlab

	% NOTE: the need for upper and lower case drive letters is a bug in matlab

	% NOTE: use the functions 'matlabroot' and 'xbat_root' to get roots
	
	ignore = { ...
		'C:\MATLAB7\toolbox\matlab\', ...
		'c:\MATLAB7\toolbox\matlab\', ...
		'C:\Harold\Matlab\XBAT\', ...
		'c:\Harold\Matlab\XBAT\' ...
	};

end

%--
% get ignore string lengths for efficient comparison later
%--

for k = 1:length(ignore)
	len(k) = length(ignore{k});
end

%-----------------------------------------
% GET FUNCTIONS IN MEMORY AND DISPLAY
%-----------------------------------------

%--
% get m and mex functions in memory
%--

[fun,mex] = inmem;

fun = {fun{:}, mex{:}}';

%--
% display location of functions in memory
%--

i = 0;

for k = 1:length(fun)
	
	%--
	% get location string if available
	%--
	
	str = which(fun{k}); 
	
	%--
	% ignore functions from certain paths
	%--
	
	for j = 1:length(ignore)
		if ((length(str) > len(j)) && strncmp(ignore{j},str,len(j)))
			str = [];
			break;
		end
	end 
	
	%--
	% display locations not ignored
	%--
	
	if (~isempty(str))
		i = i + 1;
		out{i} = str;
	end
	
end

%--
% return on empty
%--

if (i == 0)
	out = cell(0);
end

%--
% put output in sorted column array
%--

out = sort(out(:));

%--
% display output
%--

disp(' ');

for k = 1:length(out)
	disp([int2str(k) '. ' out{k}]);
end

disp(' ');
