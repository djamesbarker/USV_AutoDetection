function [Y,IX] = nms4(x,s)

% nms4 - non-maximum suppression using scale-space significance
% -------------------------------------------------------------
%
% [Y,IX] = nms4(x,s)
%
% Input:
% ------
%  x - input sequence
%  s - sequence of smoothing scales 
%
% Output:
% -------
%  Y - smoothed sequences
%  IX - peak tracks

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
% $Revision: 513 $
% $Date: 2005-02-09 21:06:29 -0500 (Wed, 09 Feb 2005) $
%--------------------------------

% NOTE: this function should be throughly profiled and optimized

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set default smoothing scale sequence
%--

if ((nargin < 2) || isempty(s))
	s = 4:4:32;
end

%--
% get number of scales and ensure odd scales
%--

ns = length(s);

s = s + ~mod(s,2);

%--------------------------------------------
% SMOOTH SEQUENCE
%--------------------------------------------

% NOTE: make the smoothing method an option

% NOTE: we should consider non-linear smoothing as well

%--
% align input and preallocate output
%--

x = x(:)';

nx = length(x);

Y = zeros(ns,nx);

%--
% compute smoothed sequences
%--

% NOTE: a scale-space smoothing method should be used

for k = 1:ns
		
	if (s(k) > 1)
		Y(k,:) = linear_filter(x,filt_binomial(1,s(k)));
	else
		Y(k,:) = x;
	end

end

%--------------------------------------------
% FIND PEAKS IN SEQUENCES
%--------------------------------------------

% NOTE: consider packing 'fast_peak_valley' output as part of the function

for k = 1:ns
	[P(k).ix,P(k).height,P(k).width] = fast_peak_valley(Y(k,:),1);
end

% NOTE: we can look at length of peak sequences to check scale-space assumption

%--------------------------------------------
% MATCH PEAKS IN ADJACENT SEQUENCES
%--------------------------------------------

% NOTE: we could handle tracking of all extrema

M(ns) = P(ns);

for k = (ns - 1):-1:1
	M(k) = peak_match(M(k + 1),P(k),Y(k,:));
end

%--------------------------------------------
% OUTPUT INDICES
%--------------------------------------------

for k = 1:ns
	IX(k,:) = M(k).ix;
end

%--------------------------------------------
% DISPLAY RESULTS
%--------------------------------------------

if (~nargout)
	
	fig;
	
	%--
	% display smooth and coarse signals
	%--
	
	plot(Y(1,:),'b:');
	hold on;
	plot(Y(ns,:),'b');
	
	%--
	% display scale-space nms peaks on smooth and coarse signals
	%--
	
	plot(M(1).ix,Y(1,M(1).ix),'ro');
	
	plot(M(ns).ix,Y(ns,M(ns).ix),'ro');

	%--
	% display peak tracks through scale space points
	%--
	
	for k = 1:length(M(1).ix)

		% NOTE: there may be a faster way to collect these
		
		for j = 1:ns 
			px(j) = M(j).ix(k);
			py(j) = Y(j,px(j));
		end

		plot(px,py,'r-+');

	end
	
end

%--------------------------------------------
% PEAK_MATCH
%--------------------------------------------

% NOTE: this is the heart of this function, as well as the most intense

function M = peak_match(S,D,V)

% peak_match - match peaks in smooth sequence to detail sequence
% --------------------------------------------------------------
% 
% M = peak_match(S,D,V)
%
% Input:
% ------
%  S - smooth peaks structure
%  D - detail peaks structure
%  V - detail values
%
% Output:
% -------
%  M - matched peak structure (subset of the detail peaks)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 513 $
% $Date: 2005-02-09 21:06:29 -0500 (Wed, 09 Feb 2005) $
%--------------------------------

% NOTE: peak source sequences are on the same grid 

% NOTE: source of smooth peaks is a smoothed version of detail peaks source

% NOTE: this implements scale-space ideas of peak tracking across scale

%--
% find a match for each smooth peak
%--

out = zeros(size(S.ix));

for k = 1:length(S.ix)

	%--
	% get indices of detail peaks in support zone of smooth peak
	%--

	d = D.ix - S.ix(k);

	cix = find((d >= -S.width(1,k)) & (d <= S.width(2,k)));
	
	%--
	% get detail peak values and select the max
	%--

	[ignore,m] = max(V(D.ix(cix)));

	%--
	% store matching detail peak index
	%--

	% NOTE: ties are handled silently and arbitrarily at the moment

	out(k) = cix(m(1));

end

%--
% output matched detail peaks
%--

M.ix = D.ix(out);

M.height = D.height(:,out);

M.width = D.width(:,out);
