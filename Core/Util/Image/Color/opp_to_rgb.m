function Y = opp_to_rgb(X)

% opp_to_rgb - opponent colors to rgb conversion
% ----------------------------------------------
%
% Y = opp_to_rgb(X)
%
% Input:
% ------
%  X - opponent colors image
%
% Output:
% -------
%  Y - rgb image

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
% opponent colors to rgb transformation
%--

V = [ ...
	1, -1, 0; ...
	2/3, 2/3, -4/3; ...
	1, 1, 1 ...
];

%--
% apply transformation
%--

Y = rgb_reshape(rgb_vec(X)*V,m,n);

%--
% enforce positivity
%--

Y(find(Y < 0)) = 0;
