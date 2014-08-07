function Y = rgb_to_opp(X)

% rgb_to_opp - rgb to opponent colors conversion
% ----------------------------------------------
%
% Y = rgb_to_opp(X)
%
% Input:
% ------
%  X - rgb image
%
% Output:
% -------
%  Y - opponent colors image

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
% get size of input
%--

[m,n,d] = size(X);

if (d ~= 3)
	disp(' ');
	error('Input image does not have three channels.');
end

%--
% make double image
%--

X = double(X);

%--
% rgb to opponent color transformation
%--

V = [ ...
	1/2, 1/4, 1/3; ...
	-1/2, 1/4, 1/3; ...
	0, -1/2, 1/3 ...
];

%--
% apply transformation
%--

Y = rgb_reshape(rgb_vec(X)*V,m,n);
