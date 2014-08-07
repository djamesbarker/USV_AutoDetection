function Y = lut_dB(X,b,c,Z)

% lut_dB - fast dB conversion 
% ---------------------------
%
% Y = lut_dB(X,b,c,Z)
%
% Input:
% ------
%  X - input image
%  b - input limits
%  c - calibration offset (lut offset)
%  Z - computation mask
%
% Output:
% -------
%  Y - image in dB units

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
% $Revision: 980 $
% $Date: 2005-04-27 14:33:11 -0400 (Wed, 27 Apr 2005) $
%--------------------------------

% TODO: create an inverse dB table

%---------------------------------
% HANDLE INPUTS
%---------------------------------

%--
% set mask
%--

if ((nargin < 4) | isempty(Z))
	Z = [];
end

%--
% set offset
%--

if ((nargin < 3) | isempty(c))
	c = 0;
end

%--
% set limits
%--

if ((nargin < 2) | isempty(b))
	b = fast_min_max(X);
end

%---------------------------------
% COMPUTE LOOK UP
%---------------------------------

% TODO: compare evaluation more thoroughly and possibly improve LUT code

if (1)
	
	%--
	% create lut applying offset if needed
	%--

	% NOTE: an unevenly spaced table would be smaller, the code not as simple

	L = lut_fun(@decibel,b,2048);

	if (c)
		L = L + c;
	end

	%--
	% apply look up table
	%--

	% TODO: review the behavior of 'lut_apply' for values out of range

	Y = lut_apply(X,L,b,Z);
	
else
	
	%--
	% compute decibels directly
	%--

	Y = decibel(X);

end

