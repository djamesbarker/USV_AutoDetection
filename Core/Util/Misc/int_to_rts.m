function rts = int_to_rts(in, large, pad)

%%  int_to_rts - convert integers to strings, padding added to end
% Added to XBAT_R5/Core/Misc by Chris Pelkie 20091105
% based on int_to_str.m already present in XBAT_R5
% ----------------------------------------
%
% rts = int_to_rts(in, large, pad)
%
% Input:
% ------
%  in - integers 
%  large - largest integer to consider
%  pad - character to use for prefix
%
% Output:
% -------
% CRP 20091106
%  rts - padding added to tail of str instead of head

% Copyright (C) 2002-2007 Harold K. Figueroa (hkf1@cornell.edu)
% Copyright (C) 2005-2007 Matthew E. Robbins (mer34@cornell.edu)
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

rts = int_to_str(in);

%------------------------
% PADDING
%------------------------

% NOTE: check if padding is requested or possible

if (nargin < 2) || isempty(large)
	return;
end

% NOTE: pack single string in cell for convenience

pack = ischar(rts);

if pack
	rts = {rts};
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
	
	if length(rts{k}) < width
        rts{k} = [rts{k}, char(pad * ones(1, width - length(rts{k})))];
	end
	
end

if pack
	rts = rts{1};
end
