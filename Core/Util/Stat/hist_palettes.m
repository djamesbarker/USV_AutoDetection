function out = hist_palettes(h,str)

% hist_palettes - create histogram palettes
% -----------------------------------------
%
% PAL = hist_palettes
%
% g = hist_palettes(h,str)
%
% Input:
% ------
%  h - histogram figure handle
%  str - toy name
%
% Output:
% -------
%  PAL - names of histogram view palettes
%  g - toy figure handle

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
% $Revision: 1.2 $
% $Date: 2003-07-16 03:46:10-04 $
%--------------------------------

%--
% create list of available toys (palettes)
%--

% 'Navigate Log', ... % this palette is not implemented yet
	
PAL = { ...
	'Histogram' ...
};

%--
% output palette names
%--

if (~nargin)
	out = PAL;
	return;
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Show';
end

%--
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% check for existing palette and bring to front and center
%--

out = get_palette(h,str);

if (~isempty(out))
	
	%--
	% bring to front
	%--

	figure(out);
	
	%--
	% center in parent
	%--
	
	%--
	% get parent and palette positions
	%--
	
	par = get(h,'position');
	pal = get(out,'position');
	
	%--
	% compute and set palette position
	%--
	
	pal(1) = par(1) + (par(3) / 2) - (pal(3) / 2);
	pal(2) = par(2) + ((3 * par(4)) / 4) - pal(4);
	
	set(out,'position',pal);
	
	%--
	% return
	%--
	
	return;
	
end

%--
% get parent userdata
%--

data = get(h,'userdata');
		
%--
% show palettes
%--

switch (str)
	
	%-----------------------------------
	% Colormap Palette
	%-----------------------------------
	
	case ('Histogram')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		%--
		% Colormap
		%--
				
		tmp = colormap_to_fun;
		ix = find(strcmp(tmp,data.browser.colormap.name));
		if (isempty(ix))
			ix = 1;
		end
	
		control(1) = control_create( ...
			'name','Colormap', ...
			'tooltip','Colormap of image display', ...
			'style','popup', ...
			'space',1.5, ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
	
		%--
		% Separator
		%--
		
		control(2) = control_create( ...
			'style','separator' ...
		);
	
		%--
		% Brightness
		%--
		
		control(3) = control_create( ...
			'name','Brightness', ...
			'tooltip','Center of dynamic range', ...
			'style','slider', ...
			'value',data.browser.colormap.brightness ...
		);
	
		%--
		% Contrast
		%--
		
		control(4) = control_create( ...
			'name','Contrast', ...
			'tooltip','Width of dynamic range', ...
			'style','slider', ...
			'value',data.browser.colormap.contrast ...
		);
	
		%--
		% Auto Scale
		%--
		
		control(5) = control_create( ...
			'name','Auto Scale', ...
			'tooltip','Toggle automatic scaling of colormap (A)', ...
			'style','checkbox', ...
			'space',1, ...
			'lines',0, ...
			'value',data.browser.colormap.auto_scale ...
		);
	
		%--
		% Separator
		%--
		
		control(6) = control_create( ...
			'style','separator' ...
		);

		%--
		% Invert
		%--
		
		control(7) = control_create( ...
			'name','Invert', ...
			'tooltip','Toggle inversion of colormap (I)', ...
			'style','checkbox', ...
			'space',0.75, ...
			'lines',0, ...
			'value',data.browser.colormap.invert ...
		);
	
		%--
		% Colorbar
		%--
		
		tmp = ~isempty(findobj(h,'tag','Colorbar','type','axes'));
		
		control(8) = control_create( ...
			'name','Colorbar', ...
			'tooltip','Toggle display of colorbar (C)', ...
			'style','checkbox', ...
			'space',0.75, ... 
			'lines',0, ...
			'value',tmp ...
		);
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 8;
		opt.top = 0.5;
		opt.bottom = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		set(out, ...
			'tag',['HIST_PALETTE::' str], ...
			'keypressfcn',['palette_kpfun(' num2str(h) ');'] ...
		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','hist_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%--
		% update controls state
		%--
		
		if (data.browser.colormap.auto_scale)
			control_update(h,'Colormap','Brightness','__DISABLE__');
			control_update(h,'Colormap','Contrast','__DISABLE__');
		end
		
		if (data.browser.colormap.contrast == 0)
			control_update(h,'Colormap','Brightness','__DISABLE__');
		end
	
	%--
	% Show
	%--
	
	case ('Show')
		
		%--
		% hide palettes
		%--
		
		tmp = findobj(0,'type','figure');
		
		tag = get(tmp,'tag');
		ix = strmatch('HIST_PALETTE',tag);
		
		set(tmp(ix),'visible','off');
		
		%--
		% make palettes visible and bring to the front
		%--
				
		flag = 0;
		
		for k = length(data.browser.palettes):-1:1
			
			tmp = data.browser.palettes(k);
			
			if (ishandle(tmp))
				set(tmp,'visible','on');
				figure(tmp);
			else
				data.browser.palettes(k) = [];
				flag = 1;
			end
			
		end
		
		%--
		% update userdata if needed
		%--
		
		if (flag)
			set(h,'userdata',data);
		end
		
		%--
		% output nothing
		%--
		
		out = [];

end

%--
% position palette
%--

if (~isempty(out))
	
	%--
	% get parent and palette positions
	%--
	
	par = get(h,'position');
	pal = get(out,'position');
	
	%--
	% compute and set palette position
	%--
	
	pal(1) = par(1) + (par(3) / 2) - (pal(3) / 2);
	pal(2) = par(2) + ((3 * par(4)) / 4) - pal(4);
	
	set(out,'position',pal);
	
end
