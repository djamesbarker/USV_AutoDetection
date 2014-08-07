function value = is_handles(in, type)

% is_handles - check input is handles possibly of a type
% ------------------------------------------------------
%
% value = is_handles(in, type)
%
% Input:
% ------
%  in - input array
%  type - required handle type
%
% Output:
% -------
%  value - result of test

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
% check input is handles
%--

value = 1;

if ~all(ishandle(in))
	value = 0; return;
end

if nargin < 2
	return;
end

%--
% check handle types
%--

if any(~strcmp(get(in, 'type'), type))
	value = 0;
end
