function y = power_pdf(x,p)

% power_pdf - one sided power law pdf
% -----------------------------------
%
% y = power_pdf(x,p)
%
% Input:
% ------
%  x - points to evaluate
%  p - generalized gaussian parameters [mean, deviation, shape]
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

y = gauss_pdf_(x,p(3),p(2),p(1));

% set lower than mean values to zero

ix = find(x < p(1));
y(ix) = 0;
