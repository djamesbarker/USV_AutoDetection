function p = vario_to_pdf(g,b)

% vario_to_pdf - variogram to pdf transformation
% ----------------------------------------------
% 
%  p = vario_to_pdf(g)
%
% Input:
% ------
%  g - variogram
%  b - linking interval
%
% Output:
% -------
%  p - probability

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
% parse interval
%--

b = parse_interval(b);

%--
% compute intensity
%--

g = sqrt(g);
p = zeros(size(g));

for k = 1:length(g)
	p(k) = 2*(normcdf(b(2),0,g(k)) - normcdf(b(1),0,g(k)));
end

%--
% discrete normalization to get probability
%--

p = p/sum(p);

