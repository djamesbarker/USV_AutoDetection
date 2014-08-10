function [X, context] = compute(X, parameter, context)

% SLICE NORMALIZATION - compute

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

X = normalize_dim(X, 1, parameter);

% rows = size(X, 1);
% 
% if parameter.center
% 	X = X - (ones(rows, 1) * mean(X, 1));
% end
% 
% if parameter.normalize
% 	X = X ./ (ones(rows, 1) * sqrt(sum(X.^2, 1)));
% end
