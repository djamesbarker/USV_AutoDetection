function p = figs_cascade(h)

% figs_cascade - cascade figure windows
% -------------------------------------
%
% p = figs_cascade
%   = figs_cascade(h)
%
% Input:
% ------
%  h - handles of figures to cascade
%
% Output:
% -------
%  p - position coordinates for each figure

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

%--
% get screensize (this is in pixels, the default 'units' value for 'root')
%--

ss  = get(0,'screensize');

%--
% set handles
%--

if ((nargin < 1)| isempty(h))
	
	%--
	% get open figures
	%--
	
	h = get_figs;
	
	if (isempty(h));
		return;
	end
	
end

%--
% sort figures and get number of them
%--

h = sort(h);

% remove figures that are not resizable

for k = length(h):-1:1
	if (strcmp(get(h(k),'resize'),'off'))
		h(k) = [];
	end
end

if (isempty(h))
	return;
end

n = length(h);

%--
% compute figure positions and cascade figures if needed
%--

for k = 1:n
		
	%--
	% cascade figures
	%--

	% it is not clear that this is the way to go. for example, what if we want
	% to cascade palettes? for the moment this deals with an error, the source
	% of the error should be fixed and this code removed

	if (strcmp(get(h(k),'resize'),'on'))
		
		figure(h(k));
		
		%--
		% compute cascade postion
		%--
		
		pos = get(h(k),'position');
		pos(1:2) = [28*(k + 0), ss(4) - pos(4) - 28*(k + 1)];
		
		%--
		% make sure that figure position is specified in pixels
		%--
		
		units = get(h(k),'units');
		
		if (~strcmp(units,'pixels'))
			set(h(k),'units','pixels');
		end
		
		%--
		% set figure position
		%--
		
		while (any(get(h(k),'position') ~= pos))
			set(h(k),'Position',pos);
		end
		
		%--
		% reset figure units
		%--
		
		set(h(k),'units',units);

	end
		
	%--
	% save figure positions
	%--
	
	p(k,:) = pos;
		
end

%--
% update display of figures
%--

for k = 1:n
	
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
	
	% check for semicolon
	
	if (~isempty(resize) & (resize(end) == ';'))
		resize = resize(1:end - 1);
	end
	
	if (~isempty(resize))
		feval(resize,h(k));
	end
	
end
