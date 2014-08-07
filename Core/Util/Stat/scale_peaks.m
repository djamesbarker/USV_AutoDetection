function [ix, Y] = scale_peaks(X, scale)

% scale_peaks - find peaks significant at given scale
% ---------------------------------------------------
%
% [ix, Y] = scale_peaks(X, scale)
%
% Input:
% ------
%  X - input sequences as columns
%  scale - significance scale
%
% Output:
% -------
%  ix - peak indices in cells for multiple columns
%  Y - smoothed sequences

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

% NOTE: considering only peaks implements non-maximum supression

%--
% smooth correlation
%--

Y = linear_filter(X, filt_binomial(scale, 1));

%--
% find peaks in correlation sequence and smooth
%--

% NOTE: the output of 'fast_peak_valley' is always a row

PX = fast_peak_valley(X, 1);

[PY, height, width] = fast_peak_valley(Y, 1);

%--
% loop over smooth peaks
%--

ix = zeros(size(PY));

for k = length(PY):-1:1

	%--
	% select candidate indices for this peak
	%--

	% NOTE: peak matching scope is given by width of the smooth peak

	distance = PX - PY(k);

	selected = find( ...
		(distance > -width(1, k)) & (distance < width(2, k)) ...
	);

	%--
	% select best peak in the neighborhood
	%--

	if ~isempty(selected)
		
		%--
		% get top peak among selected peaks
		%--

		[ignore, top] = max(X(PX(selected)));
		
		% NOTE: to get the initial index dereference top using selected
		
		ix(k) = PX(selected(top));

	%--
	% select best value in zone
	%--

	% NOTE: this is typically anomalous behavior and needs work

	else

		start = PY(k) - width(1, k); stop = PY(k) + width(2, k);

		[ignore, top] = max(X(start:stop));

		ix(k) = start + top - 1;

	end

end
