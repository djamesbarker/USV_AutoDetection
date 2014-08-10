function [X, context] = compute(X, parameter, context)

% LINEAR_BASE - compute

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

% TODO: consider factoring most of this into its own function

%--
% pad signal
%--

N = size(X, 1); n = impzlength(parameter.filter.b, parameter.filter.a) - 1;

if context.debug
	info.pad = n;
end

X = [flipud(X(1:n, :)); X; flipud(X(end - n + 1:n, :))];

%--
% filter
%--

if length(parameter.filter.a) == 1
	
	%--
	% perform some tests if we are in debug
	%--
	
	if context.debug
		
		info.length = length(parameter.filter.b);
		
		%--
		% compute and time fast convolution
		%--
		
		start = clock; 
		
		X1 = fast_conv(X, parameter.filter.b); X1 = X1(n + 1: n + N, :);
		
		elapsed.fast_conv = etime(clock, start);
		
		%--
		% compute and time filter
		%--
		
		start = clock;
		
		X2 = filter(parameter.filter.b, parameter.filter.a, X); X2 = X2(n + 1: n + N, :);
		
		elapsed.filter = etime(clock, start);
		
		info.elapsed = elapsed;
		
		info.error = max(abs(X1 - X2));
		
	end
	
	% NOTE: algorithm selection could be adaptive, consider 'wisdom'
	
	if length(parameter.filter.b) > 128
		
		X = fast_conv(X, parameter.filter.b);
		
	else

		X = filter(parameter.filter.b, parameter.filter.a, X);
	
	end
	
else
 
	X = filter(parameter.filter.b, parameter.filter.a, X);

end

%--
% display debug info
%--

if context.debug
	flatten(info)
end

%--
% select valid part of signal
%--

X = X(n + 1: n + N, :);
