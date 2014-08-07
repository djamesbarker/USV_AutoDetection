function x = fm_synth(f, a, rate, oversamp)

%--
% handle input
%--

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

if nargin < 4 || isempty(oversamp)
	oversamp = 2;
end

if nargin < 3 || isempty(rate)
	rate = 3*max(f);
end

if nargin < 2 || isempty(a)
	a = 'constant';
end

%--
% fabricate amplitude envelope if necessary
%--

if ischar(a)
	
	switch a
		
		case 'constant', a = ones(size(f));
			
		case 'tapered', a = hann(length(f));
			
	end
	
end

if length(f) ~= length(a)
	error('f and a must be the same size.');
end
			
%--
% interpolate frequency track
%--

f_up = interp1(f, linspace(1, length(f), oversamp * length(f)), 'spline');

%--
% divide down to correct bandwidth
%--

f_up = 2 * pi * (f_up ./ (rate * oversamp));

%--
% separate into frequency/phase
%--

f0 = f(1); ph = seq_int(f_up - f0);

%--
% modulate
%--

x = sin((f0 * [0:(length(f_up) - 1)]) + ph);

x = resample(x, 1, oversamp);

x = a .* x;
