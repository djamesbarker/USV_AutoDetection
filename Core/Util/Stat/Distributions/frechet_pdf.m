function p = frechet_pdf(x,a,b,c)

% frechet_pdf - frechet extreme value distribution
% -----------------------------------------------
% 
% p = frechet_pdf(x,a,b,c)
%
% Input:
% ------
%  x - points to evaluate
%  a - location parameter
%  b - scale parameter
%  c - shape parameter
%
% Output:
% -------
%  p - frechet distribution

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
% compute shape of probability density function of frechet
%--

z = (x - a) ./ b;

ix = find(x <= a);
z(ix) = 0;

z1 = z.^(-c);
z2 = z1 ./ z;

p = (c / b) .* z2 .* exp(-z1);

% set division by zero points to zero

ix = find(isnan(p));
p(ix) = 0;


