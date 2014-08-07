function str = show_reg_exp(res, sep)

% show_reg_exp - display regular expression match
% -----------------------------------------------
%
% str = show_reg_exp(res, sep)
%
% Input:
% ------
%  res - match results structure
%  sep - match separator structure ('open' and 'close' fields)
%
% Output:
% -------
%  str - string display for match

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
% $Revision: 1380 $
% $Date: 2005-07-27 18:37:56 -0400 (Wed, 27 Jul 2005) $
%--------------------------------

% TODO: extent may be empty even when there is a match, handle this

%--
% set display separator patterns
%--

if (nargin < 2)
	sep.open = '<<'; sep.close = '>>';
end

%--
% build match string
%--

% NOTE: output trivial no match string

if (~length(res.start))
	str = res.str; return;
end

str = [res.str(1:res.start(1) - 1), sep.open, res.str(range(res.extent{1})), sep.close];

for k = 2:length(res.start)
	str = [ ...
		str, res.str(res.end(k - 1) + 1:res.start(k) - 1), sep.open, res.str(range(res.extent{k})), sep.close ...
	];
end

str = [str, res.str(res.end(end) + 1:end)];

%--
% utility function to expand extent
%--

function ix = range(extent)

ix = extent(1):extent(2);
