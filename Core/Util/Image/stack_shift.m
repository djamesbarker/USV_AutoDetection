function Y = stack_shift(X,n)

% stack_shift - shift cells in stack
% ----------------------------------
%
% Y = stack_shift(X,n)
%
% Input:
% ------
%  X - input stack
%  n - shift
%
% Output:
% -------
%  Y - shifted stack

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
% get effective shift
%--

nf = length(X);
n = mod(n,nf);

%--
% shift stack
%--
n
if (n > 0)
	pi, (nf - n):nf, 1:n
	Y = {X((nf - n):nf), X(1:n)};
else
	n:nf, 1:n
	Y = {X(n:nf), X(1:n)};
end
