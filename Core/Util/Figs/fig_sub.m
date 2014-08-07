function h = fig_sub(m,n,ix,h)

% fig_sub - like subplot but for figures
% --------------------------------------
%
% h = fig_sub(m,n,ix,h)
%
% Input:
% ------
%  m,n - rows and columns in tiling
%  ix - position in tiling
%  h - handle of figure to position (def: gcf)
%
% Output:
% -------
%  h - handle to figure

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
% $Date: 2003-11-05 16:00:56-05 $
%--------------------------------

%--
% compute location of figure
%--

[p,s] = figs_tile(m,n,10000); % figs_tile has a bug, 10000 is a workaround

%--
% position existing figure or create new figure and position
%--

if (ix <= (m * n))

	%--
	% set figure handle if needed
	%--
	
	if (nargin < 4 | isempty(h))
		h = gcf;
	end
	
	%--
	% position figure
	%--
	
	units = get(h,'units');
	if (~strcmp(units,'pixels'))
		set(h,'units','pixels'); 
	end
	
	set(h,'Position',[p(ix,:),s]);
	
	set(h,'units',units);
	
	%--
	% evaluate resize function if needed
	%--
	
	resize = get(h,'resizefcn');
	
	
	if (~isempty(resize))
		
		if (resize(end) == ';')
			resize = resize(1:end - 1);
		end
		
		feval(resize,h);
		
	end
		
else

	error('Position index in figure tiling exceeds size of tiling.');
	
end
