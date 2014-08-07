function str = str_implode(parts, sep, fun, trim)

% str_implode - implode cell array into separated string
% ------------------------------------------------------
%
% str = str_implode(parts, sep, fun, trim)
%
% Input:
% ------
%  parts - cell array
%  sep - separator
%  fun - to string helper (def: none)
%  trim - indicator
%
% Output:
% -------
%  str - implosion result string

% Copyright (C) 2002-2012 Cornell University
%
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
% set trim and no helper default
%--

if nargin < 4
	trim = 1;
end

if nargin < 3
	fun = [];
end

%--
% set and check separator
%--

if nargin < 2
	sep = ' ';
end

if ~ischar(sep)
	error('Separator must be string.');
end

%--
% check and prepare cell array for implosion
%--

str = '';

if isempty(parts)
	return;
end

if ~isempty(fun)
	for k = 1:numel(parts)
		parts{k} = fun(parts{k});
	end
end

if ~iscellstr(parts)	
	if isempty(fun)
		error('First input must be string cell array, unless helper is available.');
	else
		error('Input parts cell array is not a string cell array.');
	end
end

if trim
	for k = 1:length(parts)
		parts{k} = strtrim(parts{k});
	end
end

%--
% implode string cell array
%--

parts = parts(:)'; parts(2, :) = {{sep}}; parts = parts(:)'; parts(end) = [];

str = strcat(parts{:});

% NOTE: this happens because the inputs to 'strcat' are cell arrays

if iscell(str)
	str = str{1};
end
