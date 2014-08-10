function Y = moorer(X,param)

%--------------------------------
% HANDLE INPUT
%--------------------------------

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
% set and possibly output default parameters
%--

if nargin < 2 || isempty(param)
	
	param.lengths = [11, 13, 17, 19, 27] / 100;
	
	param.decay = .15;
	
	param.filt = [.5 .5];
	
	param.fs = 44100;
	
	if (~nargin)
		Y = param; return;
	end
	
end

%--
% check shape of signal
%--

% TODO: extend to handle signal provided as one channel per column

if prod(size(X)) ~= length(X)
	error('single channel signals only');
end

X = X(:);

%--------------------------------
% COMPUTE FILTER
%--------------------------------

% TODO: make it fast! this is already pretty close to C anyway

Y = zeros(size(X));

tap_starts = floor(param.lengths * param.fs);

tap_length = length(param.filt);

for ix = 1:length(X)
	
	Y(ix) = X(ix);
	
	if ix > max(tap_starts)
		
		for jx = 1:length(tap_starts)

			kx = ix - tap_starts(jx);

			Y(ix) = Y(ix) + param.decay * param.filt * Y(kx:(kx + tap_length - 1));

		end

	end
	
end
	
	



