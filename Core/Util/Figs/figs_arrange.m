function [p,s] = figs_arrange(r,c,h)

% figs_arrange - arrange figure windows (tile keeping aspect ratio)
% -----------------------------------------------------------------
%
% [p,s] = figs_arrange
%       = figs_arrange(h)
%       = figs_arrange(r,c)
%       = figs_arrange(r,c,h)
%
% Input:
% ------
%  r,c - rows and columns of tiling
%  h - handles of figures to tile
%
% Output:
% -------
%  p - position coordinates for each figure
%  s - common size of figures

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
% $Date: 2002-12-12 14:02:22-05 $
% $Revision: 1.28 $
%--------------------------------

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set figure handles
%--

if ((nargin < 3)| isempty(h))
	
	%--
	% handles are single input
	%--
	
	if (nargin == 1)
		
		h = r;

	%--
	% get handles by looking through open figures
	%--
	
	else
		
		%--
		% get open figures
		%--
		
		h = get_figs;
		
		if (isempty(h));
			return;
		end
		
		%--
		% sort figures
		%--
		
		h = sort(h);
		
	end

end

%--
% set or check tiling parameters
%--

% this common code should be reviewed and put into a private function

n = length(h);

if (nargin < 2)
	
	if (n < 13)
	
		rc = [1,1; ...
			1,2; ...
			2,2; ...
			2,2; ...
			2,3; ...
			2,3; ...
			3,3; ...
			3,3; ...
			3,3; ...
			3,4; ...
			3,4; ...
			3,4];
			
		r = rc(n,1);
		c = rc(n,2);
		
	else
			
		sq = [2:sqrt(1000)].^2;
		sq = sq(find(sq >= n));
		r = sqrt(sq(1));
		c = r;
	
	end

else
	
	if n > (r * c)
		
		disp(' ');
		warning('Number of figures exceeds tiling size.');
		disp(' ');
		
		p = [];
		s = [];
		
		return;
		
	end

end

%--
% get figure aspect rations
%--

for k = 1:length(h)
	pos = get(h(k),'position');
	ar(k) = pos(3) / pos(4);
end

%--
% tile figures
%--

figs_tile(r,c,h);

%--
% fix aspect ration of figures
%--

for k = 1:length(h)
	
	pos = get(h(k),'position');
	
	% update position
	
	new_pos = pos;
	
	new_pos(4) = pos(3) / ar(k);
	new_pos(2) = pos(2) + (pos(4) - new_pos(4));
	
	set(h(k),'position',new_pos);
	
end

%--
% move rows up if possible
%--

for k = 2:r
	
	%--
	% get minimum horizontal position of previous row
	%--
	
	height = [];
	
	for j = (c * (k - 2) + 1):(c * (k - 1))
		tmp = get(h(j),'position');
		height(end + 1) = tmp(2);
	end
	
	height = min(height);
	
	%--
	% move current row up to the previous row
	%--

	tmp = get(h(c * (k - 1) + 1),'position');
	tmp = tmp(2) + tmp(4);
	
	if (tmp < height)
		
		offset = (height - tmp) - 53;
		
		for j = (c * (k - 1) + 1):min(n,(c * k))
			pos = get(h(j),'position');
			pos(2) = pos(2) + offset;
			set(h(j),'position',pos);
		end
		
	end
	
end

%--
% update display of figures
%--

% this common code needs to be reviewed and put into a private function

if ~nargout
	
	for k = 1:length(h)
		
		%--
		% refresh figures
		%--
		
		refresh(h(k));
		
		%--
		% execute resize function if needed
		%--
		
		resize = get(h(k), 'resizefcn');
		
		% check for non-empty resize and semicolon
		
		if ~isempty(resize) && ischar(resize) && (resize(end) == ';')
			resize = resize(1:end - 1);
		end
					
		if ~isempty(resize)
			feval(resize, h(k));
		end
		
	end
	
end
