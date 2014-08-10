function X = compute(parameter, context)

% NOISE - compute

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

X = [];

rate = get_sound_rate(context.sound);

N = floor(context.page.duration * rate);

distribution = parameter.distribution{1};

if isempty(distribution)
	distribution = 'gaussian';
end

switch distribution
	
	case 'gaussian', X = randn(N, numel(context.page.channels));

	case 'uniform', X = 2 * rand(N, numel(context.page.channels)) - 1;
		
	case 'heavy', X = rand_tan(N, numel(context.page.channels));
		
	otherwise
		
end

X = X * parameter.variance;

if isempty(parameter.filter)
	return;
end

X = filter(parameter.filter.b, parameter.filter.a, X);
