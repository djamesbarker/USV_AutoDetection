function [X, context] = compute(X, parameter, context)

% IMPULSE-NOISE - compute

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
% get uniform noise vector and probability of impulse
%--

N = rand(size(X)); p = parameter.percent / 100;

%--
% select positions and place impulses
%--

switch lower(parameter.type{1})
	
	case 'mixed', X(N > (1 - 0.5 * p)) = 1; X(N < 0.5 * p) = -1;
		
	case 'negative', X(N < p) = -1;
		
	case 'positive', X(N < p) = 1;
		
end
