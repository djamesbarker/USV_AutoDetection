function [ix, h, w] = fast_peak_valley(x, type)

% fast_peak_valley - fast extrema computation
% -------------------------------------------
%
% [ix, h, w] = fast_peak_valley(x, type)
%
% Input:
% ------
%  x - input sequence
%  type - type of extrema (def: 0)
%
% Output:
% -------
%  ix - extrema indices
%  h - extrema heights or depths
%  w - extrema widths

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
% $Revision: 943 $
% $Date: 2005-04-15 18:03:43 -0400 (Fri, 15 Apr 2005) $
%--------------------------------

% TODO: align input and output for vectors

% TODO: generalize code to handle matrices and take dimension input

% TODO: include opt as part of the low level computation

% NOTE: the current approach used to separate peaks is not intuitive

%--
% set output option
%--

if (nargin < 2) || isempty(type)
	type = 0;
end

%--
% compute peaks and valleys and select one class for output if needed
%--

switch nargout
	
	case 1
		
		ix = fast_peak_valley_(x);
		
		if type
			
			if type > 0
				ix = ix(ix > 0);
			else
				ix = -ix(ix < 0);
			end
			
		end
		
	case 2
		
		[ix, h] = fast_peak_valley_(x);
		
		if type
			
			if (type > 0)
				tmp = find(ix > 0); ix = ix(tmp); h = h(:, tmp);
			else
				tmp = find(ix < 0); ix = -ix(tmp); h = h(:, tmp);
			end
			
		end
		
	case 3
		
		[ix, h, w] = fast_peak_valley_(x);
		
		if type
			
			if (type > 0)
				tmp = find(ix > 0); ix = ix(tmp); h = h(:, tmp); w = w(:, tmp);
			else
				tmp = find(ix < 0); ix = -ix(tmp); h = h(:, tmp); w = w(:, tmp);
			end
			
		end
		
end


