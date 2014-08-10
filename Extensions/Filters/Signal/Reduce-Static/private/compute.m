function [X, context] = compute(X, parameter, context)

% REDUCE-STATIC - compute

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

% TODO: develop true multiple channel computation

switch lower(parameter.quality{1})
	
	case 'low'
		
		% NOTE: we can test whether we need to remove edges, however this is cheap
			
		ix = find(abs(X) > parameter.level); ix = ix(2:end);
	
		X(ix) = 0.5 * (X(ix - 1) + X(ix + 1));
		
	case 'medium'
		
		% TODO: this code has problems ... not clear yet what
		
		ix = find(abs(X) > parameter.level); N = length(X); 
		
		kix = setdiff(1:N, ix); Y = X(kix);
		
		X(ix) = interp1q(kix', Y, ix);
		
	case 'high'
		
end

% NOTE: careful impulse selection is yet to be considered in this code
