function [X, context] = compute(X, parameter, context)

% CLIP - compute

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
% clip using oversampling
%--

if parameter.oversample > 1
	
	X = resample(X, parameter.oversample, 1);

	X = sign(X) .* min(abs(X), 0.01 * parameter.percent_level);

	X = resample(X, 1, parameter.oversample);

%--
% clip directly
%--

else
	
	X = sign(X) .* min(abs(X), 0.01 * parameter.percent_level);
	
end
