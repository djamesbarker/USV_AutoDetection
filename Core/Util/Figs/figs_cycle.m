function figs_cycle(t,h)

% figs_cycle - cycle through open figure windows
% ----------------------------------------------
%
% figs_cycle(t,h)
%
% Input:
% ------
%  t - time between figures (def: -1)
%  h - figure handles

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
% $Revision: 1.1 $
% $Date: 2003-11-05 16:00:57-05 $
%--------------------------------

%--
% set figure handles
%--

if (nargin < 2)
	h = get(0,'children');
	h = sort(h);
end

%--
% set and check pause interval
%--

if (~nargin)
	t = -1;
end

tn = length(t);
hn = length(h);

if (tn == 1)
	for k = 1:hn
		v(k) = t;
	end
	t = v;
elseif (tn ~= hn)
	error('Improper length of pause interval variable.');
end
	
%--
% cycle through windows
%--

for k = 1:length(h)
	
	figure(h(k)); 
	
	if (t > 0)
		pause(t);
	else
		pause;
	end
	
end
