function L = frechet_likelihood(p,X)

% frechet_likelihood - frechet log likelihood
% -----------------------------------------
%
% L = frechet_likelihood(p,X)
%
% Input:
% ------
%  p - frechet parameters
%  X - input data
%
% Output:
% -------
%  L - negative log likelihood of data

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
% put data in vector and separate parameters
%--

x = X(:);

a = p(1);
b = p(2);

%--
% compute negative log likelihood
%--

d = -x + a;
z = d / b;

L = sum((1 / b) * exp((d - (b * exp(z))) / b));
% L = -L;
