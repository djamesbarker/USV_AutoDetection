function d = hist_divergence(p,q)

% hist_divergence - compute kullback divergence of histograms
% -----------------------------------------------------------
%
% d = hist_divergence(p,q)
%
% Input:
% ------
%  p,q - histograms over same events
%
% Output:
% -------
%  d - kullback divergence

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
% $Date: 2005-12-15 13:52:40 -0500 (Thu, 15 Dec 2005) $
% $Revision: 2304 $
%--------------------------------

%--
% normalize histograms if needed
%--

s = sum(p(:)); 
if (s ~= 1)
	p = p / s;
end

s = sum(q(:));
if (s ~= 1)
	q = q / s;
end

%--
% remove p zero bins
%--

ix = find(p > 0);
p = p(ix);
q = q(ix);

%--
% handle q zero bins
%--

if (any(q == 0))
	warning('Kullback divergence may be infinite.');
end

ix = find(q > 0);
p = p(ix);
q = q(ix);

%--
% compute kullback divergence
%--

d = sum(p.*log2(p./q));




