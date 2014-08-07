function [p,s] = figs_tile(r,c,h)

% figs_tile - tile figure windows
% -------------------------------
%
% [p,s] = figs_tile
%       = figs_tile(h)
%       = figs_tile(r,c)
%       = figs_tile(r,c,h)
%
% Input:
% ------
%  h - handles of figures to tile
%  r,c - rows and columns for tiling
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

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

%--
% get screensize (this is obtained in pixels, the default 'units' value for 'root')
%--

ss  = get(0,'screensize');

% NOTE: compute screen aspect ratio

AR = ss(3) / ss(4);

%--
% set handles
%--

if ((nargin < 3)| isempty(h))
	
	if (nargin == 1)
		
		h = r;
		n = length(h);
		
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
		n = length(h);
		
	end

else
	
	n = length(h);
	
end

%--
% set check tiling parameters
%--

if (nargin < 2)

	switch (n)
		
		case (1)
			r = 1; c = 1;
			
		case (2)
			r = 1; c = 2;
			
		case (3)
			r = 2; c = 2;
			
		otherwise
			
			%--
			% compute possible rectangles for a range of compatible values
			%--

			R = rect_factor(n:floor(1.25 * n));

			%--
			% select the tiling with the minimal aspect ratio distortion
			%--

			ar = R(:,2) ./ R(:,1);
		
			% NOTE: consider refinements of this function
			
			[m,ix] = min( ...
				abs(ar - AR) + ...				% aspect ratio distortion
				(0.5 / R(end,2)) * R(:,2) ...	% number of columns
			);

			r = R(ix,1); c = R(ix,2);
			
	end
	
	%--
	% OLDER COMPUTATION
	%--
	
% 	if (n < 13)
% 	
% 		rc = [1,1; ...
% 			1,2; ...
% 			2,2; ...
% 			2,2; ...
% 			2,3; ...
% 			2,3; ...
% 			3,3; ...
% 			3,3; ...
% 			3,3; ...
% 			3,4; ...
% 			3,4; ...
% 			3,4];
% 			
% 		r = rc(n,1);
% 		c = rc(n,2);
% 		
% 	else
% 			
% 		% NOTE: there should be a better way of computing rows and columns
% 		
% 		sq = [2:sqrt(1000)].^2;
% 		sq = sq(find(sq >= n));
% 		r = sqrt(sq(1));
% 		c = r;
% 	
% 	end

end

%--
% check tiling parameters
%--

if (n > (r * c))

	disp(' ');
	warning('Number of figures exceeds tiling size.');
	disp(' ');

	p = []; 
	s = []; 

	return;

end

%-----------------------------------------
% COMPUTE AND POSSIBLY PERFORM TILING
%-----------------------------------------

%--
% compute figure width and height
%--

s = [fix(ss(3)/c) - 8, fix(ss(4)/r) - 53];

%--
% compute figure positions and tile figures if needed
%--

k = 0;

for iy = 1:r

	%--
	% compute row location
	%--
	
    y = ss(4) - fix((iy)*ss(4)/r);

	for ix = 1:c
	
		%--
		% compute column location
		%--
		
        x = fix((ix - 1)*ss(3)/c + 1) + 2;      
		k = k + 1;
		
		%--
		% position figures or save position
		%--
		
		xy = [x y];
		
		if (~nargout)
			
			%--
			% tile figures
			%--
			
		   	if (k <= n)
				
				if (strcmp(get(h(k),'resize'),'on'))
					
					figure(h(k));
					pos = [xy, s];
					
					% make sure that figure's position is specified properly
					
					units = get(h(k),'units');
					
					if (~strcmp(units,'pixels'))
						set(h(k),'units','pixels');
					end
					
					while (any(get(h(k),'position') ~= pos))
						set(h(k),'Position',pos);
					end
					
					set(h(k),'units',units);

				end
				
			end
			
		else
			
			%--
			% save figure positions
			%--
			
			p(k,:) = xy;
			
		end
	
	end
	
end

%--
% update display of figures
%--

if (~nargout)
	
	for k = 1:length(h)
		
		%--
		% refresh figures
		%--
		
		refresh(h(k));
		
		%--
		% execute resize function if needed
		%--
		
		resize = get(h(k),'resizefcn');
		
		% NOTE: currently we don't execute function handle resize functions
	
		if (~isstr(resize))
			return;
		end
	
		% check for non-empty resize and semicolon
		
		if (~isempty(resize) && (resize(end) == ';'))
			resize = resize(1:end - 1);
		end
					
		if (~isempty(resize))
			feval(resize,h(k));
		end
		
	end
	
end
