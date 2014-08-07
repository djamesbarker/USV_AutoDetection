function [rle,part,Y] = interview(X)

%-----------------------------------------------------------
% PROBLEM 1: run-length encode 
%-----------------------------------------------------------

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

x = [0, X(:)', 0];

rle.size = size(X);

rle.init = X(1);

rle.code = diff(find(diff(x)));

%-----------------------------------------------------------
% PROBLEM 2: decompose into increasing and decreasing
%-----------------------------------------------------------

d = diff(x);

z = zeros(size(x)); 

up = z; up(d > 0) = 1;

down = z; down(d < 0) = -1;

part.up = cumsum(up(1:end - 2));

part.down = cumsum(down(1:end - 2));

%-----------------------------------------------------------
% PROBLEM 3: run-length decode 
%-----------------------------------------------------------

x = cumsum(rle.code);

d = (-1).^(1:length(x));

Y(x) = d;

Y = [rle.init, Y];

Y = cumsum(Y(1:end - 1));

Y = reshape(X,rle.size);
