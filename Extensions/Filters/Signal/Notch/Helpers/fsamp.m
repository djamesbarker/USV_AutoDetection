function [h] = fsamp(F, H, D)

% fsamp - frequency sampling filter design
% ----------------------------------------
%
% h = fsamp(F, H, D)
%
% Input:
% ------
%  F - frequencies
%  H - magnitudes
%  D - total delay of filter (optional)
%
% Output:
% -------
%  h - impulse response

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
% Author: Matt Robbins
%--------------------------------
% $Revision$
% $Date$
%--------------------------------

H = H(:); F = F(:);

%--
% make frequency response two-sided
%--

if F(end) == 0.5	
	
	F = [F; flipud(1 - F(2:end-1))];	
	H = [H; flipud(H(2:end - 1))];	
	
else
	
	F = [F; flipud(1 - F(2:end))];
	H = [H; flipud(H(2:end))];
	
end

%--
% make linear phase progression
%--

if nargin < 3 || isempty(D)
	D = floor(length(F) / 2) - 1;
end

ph = exp(j*2*pi*D*F);

%--
% make DTFT matrix
%--
	
N = length(F);

FT = dtft(F, N);

%--
% design filter
%--

h = real(inv(FT)*(H.*ph));

%--
% freqz if needed
%--

if ~nargout
	freqz(h);
end

%--------------------------------------
% DTFT
%--------------------------------------

function FT = dtft(F, N)

% dtft - make arbitrary dtft matrix
% --------------------------------

FT = zeros(N);

for k = 1:N
	FT(k,:) = exp(j*2*pi*F(k)*[0:N-1]);
end
