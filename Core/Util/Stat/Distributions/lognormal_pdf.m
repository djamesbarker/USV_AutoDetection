function y = lognormal_pdf(x,p)

% lognormal_pdf - compute lognormal pdf
% -------------------------------------
% 
% y = lognormal_pdf(x,p)
%
% Input:
% ------
%  x - points to evaluate
%  p - lognormal parameters [mean, deviation]
%
% Output:
% -------
%  y - pdf values

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
% evaluate pdf at points
%--

z2 = ((log(x) - p(1)) ./ p(2)).^2;

y = (1 ./ (sqrt(2*pi) * p(2) .* x)) .* exp(-z2 ./ 2);

% fig; plot(x,y); axes_scale_bdfun(gca);
