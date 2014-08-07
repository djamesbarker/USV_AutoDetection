function [Y, R] = comp_sieve(X, str)

% comp_sieve - separate components using size thresholds
% ------------------------------------------------------
%
%  [Y, R] = comp_sieve(X, str)
%
% Input:
% ------
%  X - label image
%  str - size interval string
%
% Output:
% -------
%  Y - result image
%  R - removed image

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2006-06-06 17:29:13 -0400 (Tue, 06 Jun 2006) $
% $Revision: 5169 $
%--------------------------------

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% check for color image
%--

if (ndims(X) > 2)
	error('Color images are not supported.');
end

%------------------------------
% COMPUTE
%------------------------------

%--
% compute component sizes
%--

% NOTE: this is done by computing a histogram over labels

M = max(X(:));

h = hist_1d(X, M + 1);

%--
% get labels of blobs in size range
%--

d = select_labels(h, str);

%--
% create and apply look-up table to sieve components
%--

% NOTE: this is done by mapping labels of undesired components to zero

L = 0:M; L(d) = 0;

Y = lut_apply(X, L);

%--
% get removed blobs image if needed
%--

if (nargout > 1)
	R = X - Y;
end


%------------------------------
% SELECT_LABELS
%------------------------------

function labels = select_labels(h, str)

%--
% get interval edges and type
%--

[edge, type] = parse_interval(str);

%--
% select labels based on size distribution and interval
%--

% NOTE: the equivalent find then intersect approach is much less efficient 
	
% labels = intersect(find(h > edge(1)), find(h < edge(2)));
	
switch (type)
	
	case (0), labels = find((h > edge(1)) & (h < edge(2)));
		
	case (1), labels = find((h > edge(1)) & (h <= edge(2)));
		
	case (2), labels = find((h >= edge(1)) & (h < edge(2)));
		
	case (3), labels = find((h >= edge(1)) & (h <= edge(2)));
		
end
