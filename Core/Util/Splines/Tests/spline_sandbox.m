function h = spline_sandbox(y, data, par_tag)

% spline_sandbox - play with splines, make castles, whatever
% ----------------------------------------------------------
%
%  h = spline_sandbox(y)
%
% Input:
% ------
%  y - y-coordinates of initial points
%
% Output:
% -------
%  h - handles to axes and lines

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

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% set default parent tag
%--

if (nargin < 3)
	par_tag = 'SPLINE_FIGURE';
end

%--
% no data if no data
%--

if nargin < 2
	data = [];
end

%--
% set some sample data
%--

if ~nargin
    y = [8 7 7 7 7 7 7 7 6]; 
end
   
%------------------------------
% CREATE SANDBOX
%------------------------------

%--
% get parent
%--

par = findobj(0, 'type', 'figure', 'tag', par_tag);

if isempty(par)
	par = figure('tag', par_tag, 'name', par_tag);
end

%--
% get axes (new figure if needed)
%--

ax_tag = 'SPLINE_AXES';

h = findobj(par,'tag',ax_tag);

if isempty(h)
	h = axes('parent',par,'tag',ax_tag);
end

%--
% kill all babies!
%--

delete(get(h, 'children'));

%--
% set limits
%--

set(h, ...
    'xlim', [-2, length(y) + 1], ...
    'ylim', [min(y) - 2, max(y) + 2] ...
);

%--
% display background image
%--

colormap(flipud(gray));

if ~isempty(data)
	image('xdata', data.x, 'ydata', data.y, 'cdata', data.c, 'parent', h);
end

hold(h, 'on')

set(par, ...
	'keypressfcn', @synth_cb ...
);

%--
% reticulate!! spline
%--

[t, yp] = spline_eval(y, [0:(length(y) - 1)], 200);

%--
% draw us some lines!
%--

h(end + 1) = line(t, yp, ...
    'tag', 'curve' ...
);

x = [0:length(y)-1];

h(end + 1) = line(x(1:2), y(1:2), ...
    'color', [0 1 0], ...
    'tag', 'phantom_left', ...
    'hittest', 'off' ...
);
   
h(end + 1) = line(x(end-1:end), y(end-1:end), ...
    'color', [0 1 0], ...
    'tag', 'phantom_right', ...
    'hittest', 'off' ...
);

h(end + 1) = line(x, y, ...
    'linestyle', 'none', ...
    'marker', 'o', ...
	'markersize', 8, ...
    'color', [1 0 0], ...
    'hittest', 'on', ...
    'buttondownfcn', {@edit_callback, 'start'}, ...
    'tag', 'knots' ...
);

%-----------------------------
% EDIT_CALLBACK
%-----------------------------

function result = edit_callback(obj, eventdata, mode, editmode)

if nargin < 4 || isempty(editmode)
	editmode = 'xy';
end

bmf = gcbf;

switch (mode)
   
    case ('stop')
        
        set(bmf, ...
            'WindowButtonMotionFcn', [], ...
            'WindowButtonUpFcn', [] ...
        );
    
    case ('start')
        
        set(bmf, ...
            'WindowButtonMotionFcn', {@edit_callback, 'move'}, ...
            'WindowButtonUpFcn', {@edit_callback, 'stop'} ...
        );
 
    case ('move')

        %--
        % get axes
        %--
        
        ax = findobj('tag', 'SPLINE_AXES');

        %--
        % get mouse pointer from parent axes
        %--
        
        p = get(ax, 'CurrentPoint'); p = p(1, 1:2);
		
		%--
		% get limits
		%--
		
		xlim = get(ax, 'xlim'); ylim = get(ax, 'ylim');
		
		p = enforce_range(p, xlim, ylim);
		
        %--
        % get line handles
        %--
        
        knots_line = findobj('parent', ax, 'tag', 'knots');
	
		spline_curve = findobj('parent', ax, 'tag', 'curve');
		
		pl = findobj('parent', ax, 'tag', 'phantom_left');
		
		pr = findobj('parent', ax, 'tag', 'phantom_right');

        %--
        % find nearest knot
        %--
		
		xdata = get(knots_line, 'xdata'); ydata = get(knots_line, 'ydata');
        
        dist = sqrt((xdata - p(1)).^2 + (ydata - p(2)).^2);
        
        [m, ix] = min(dist); 
		
		%--
		% move knot to pointer as constrained by mode
		%--
        
		if strfind(editmode, 'x')
			
			txdata = xdata;
			
			txdata(ix) = p(1); 
			
			[t, yp] = spline_eval(ydata, txdata, length(get(spline_curve, 'ydata')));
			
			%--
			% enforce functional constraints
			%--
			
			if all(diff(t) > 0.0001)		
				xdata = txdata;
			end
			
		end
		
		if strfind(editmode, 'y')
			ydata(ix) = p(2);	
		end
		
        %--
        % reticulate!!
        %--  

        [t, yp] = spline_eval(ydata, xdata, length(get(spline_curve, 'ydata')));
		
        %--
        % update line data
        %--
	
        set(knots_line, 'ydata', ydata, 'xdata', xdata);

        set(spline_curve, 'xdata', t, 'ydata', yp);
          
        set(pl, 'ydata', ydata(1:2), 'xdata', xdata(1:2));
            
        set(pr, 'ydata', ydata(end-1:end), 'xdata', xdata(end-1:end));
           
end

%--------------------------------
% SYNTH_CB
%--------------------------------

function result = synth_cb(obj, eventdata)

key = get(obj, 'currentcharacter');

ax = findobj('parent', obj, 'tag', 'SPLINE_AXES');

np = 1000;

switch(key)

	case('s')

		s_c = findobj('parent', ax, 'tag', 'curve');

		x = get(s_c, 'xdata'); y = get(s_c, 'ydata');
		
		xe = interp1(x, y, linspace(min(x), max(x), np), 'spline');

		figure; plot(xe)

end




%--------------------------------
% ENFORCE_RANGE
%--------------------------------

function p = enforce_range(p, xlim, ylim)

if p(1) < xlim(1)
	p(1) = xlim(1);
end

if p(1) > xlim(2)
	p(1) = xlim(2);
end

if p(2) < ylim(1)
	p(2) = ylim(1);
end

if p(2) > ylim(2)
	p(2) = ylim(2);
end




