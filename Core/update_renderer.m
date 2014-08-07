function render = update_renderer(h,render,data)

% update_renderer - update renderer of figure
% -------------------------------------------
%
% render = update_renderer(h,render,data)
%
% Input:
% ------
%  h - handle to figure to update
%  render - name of renderer ('Painters','ZBuffer','OpenGL')
%  data - parent figure userdata
%
% Output:
% -------
%  render - name of renderer

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
% set figure
%--

if ((nargin < 1) || isempty(h))
	h = gcf;
end

%--
% set renderer directly
%--

if ((nargin > 1) & ~isempty(render))
	
	L = { ...
		'Painters', ...
		'ZBuffer', ...
		'OpenGL' ...
	};

	ix = find(strcmp(L,render));
	
	if (~isempty(ix))
		set(h,'renderer',L{ix});
	else
		disp(' ');
		error(['Unrecognized renderer mode ''' render '''.']);
	end
	
%--
% determine appropiate renderer for figure
%--

else
	
	%--
	% get figure userdata if needed
	%--
	
	if ((nargin < 3) || isempty(data))
		data = get(h,'userdata');
	end
	
	%--
	% check selection for positive patch
	%--
	
	if (data.browser.selection.patch > 0)
		set(h,'renderer','OpenGL');
		return;
	end
	
	%--
	% check for logs with positive patch
	%--
	
	if (~isempty(data.browser.log))
		
		patch = struct_field(data.browser.log,'patch');
		
		if (any(patch > 0))
			set(h,'renderer','OpenGL');
			return;
		end
		
	end
		
	%--
	% set painters if there are no positive patch variables
	%--
	
	set(h,'renderer','Painters');
	
end

%--
% refresh figure
%--

refresh(h);
	
