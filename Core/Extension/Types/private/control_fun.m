function fun = control_fun(in)

% control_fun - control functions structure
% -----------------------------------------
%
% fun = control_fun(in)
%
% Input:
% ------
%  in - name of controlled values
% 
% Output:
% -------
%  fun - function structure

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

if (nargin < 1)
	in = 'value';
end

% NOTE: the first cell contains output names, the second cell input names

fun.create = {{'control'}, {in, 'context'}};

fun.options = {{'opt'}, {'context'}};

fun.callback = {{'result'}, {'callback', 'context'}};
