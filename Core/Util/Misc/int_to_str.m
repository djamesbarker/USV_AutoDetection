function str = int_to_str(in, large, pad)

% int_to_str - convert integers to strings
% ----------------------------------------
%
% str = int_to_str(in, large, pad)
%
% Input:
% ------
%  in - integers 
%  large - largest integer to consider
%  pad - character to use for prefix
%
% Output:
% -------
%  str - string conversion

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

%------------------------
% FAST CONVERSION
%------------------------

%--
% round and real
%--

in = real(round(in));

%--
% convert to string
%--

% NOTE: outputs a cell array for matrix inputs and a string for scalars

str = int_to_str_(in);

%------------------------
% PADDING
%------------------------

% NOTE: check if padding is requested or possible

if (nargin < 2) || isempty(large)
	return;
end

% NOTE: pack single string in cell for convenience

pack = ischar(str);

if pack
	str = {str};
end

%--
% set default padding character
%--

if nargin < 3
	pad = '0';
end

%--
% set default large
%--

% NOTE: an empty large value requests we compute this automatically

if isempty(large)
	large = max(in(:));
end

%--
% pad integers
%--

pad = double(pad); width = length(int2str(large));

for k = 1:numel(in)
	
	if length(str{k}) < width
		str{k} = [char(pad * ones(1, width - length(str{k}))), str{k}];
	end
	
end

if pack
	str = str{1};
end
