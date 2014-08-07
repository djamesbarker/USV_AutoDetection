function str = block_to_str(block, fun)

% block_to_str - scan block string
% --------------------------------
%
% str = block_to_str(block, fun)
%
% Input:
% ------
%  block - scan block
%  fun - time string function (def: @sec_to_clock)
%
% Output:
% -------
%  str - block string

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
% set conversion function
%--

if nargin < 2
	fun = @sec_to_clock;
end

%--
% create string
%--

str = ['[', fun(block(1)), ', ', fun(block(2)), ']'];
