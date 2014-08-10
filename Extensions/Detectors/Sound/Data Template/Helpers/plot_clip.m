function plot_clip(pal)

% plot_clip - produce clip plot in detector controls
% --------------------------------------------------
%
% plot_clip(pal)
%
% Input:
% ------
%  pal - handle to control palette

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
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

%------------------------------------
% GET INPUT
%------------------------------------

%--
% get axes
%--

ax = findobj(pal,'type','axes','tag','templates');

%--
% get templates from axes
%--

templates = get(ax, 'userdata');

%--
% return if there is no clip to display
%--

if isempty(templates)
	delete(allchild(ax)); return;
end

%--
% get parameter values from palette
%--

param = get_parameter_values(pal, 'sound_detector');

%------------------------------------
% CREATE CLIP IMAGE
%------------------------------------

%--
% get spectrogram parameters from parent
%--

par = get_field(get(pal, 'userdata'), 'parent');

data = get(par, 'userdata');

%--
% compute clip spectrogram
%--

% NOTE: we select the clip using the current clip index

clip = templates.clip(templates.ix);

[Bt, Bn] = template_spectrogram(clip, data.browser.sound, param);

[m, n] = size(Bt);

%------------------------------------
% DISPLAY CLIP IMAGE
%------------------------------------

%--
% clear previously displayed elements
%--

delete(findobj(pal,'tag','DELETE_ME'));

%--
% set axes for display
%--

axes(ax);

hold on;

%--
% compute masked template display
%--

if param.mask
	
	opt = mask_gray_color;	
	opt.color = [0 1 1];
	opt.alpha = 0.4;
		
	Bt = Bt .* Bn;
	
end

%--
% display image
%--

tmp = imagesc(Bt);

set(tmp, ...
	'hittest', 'off', ...
	'xdata', [0, clip.event.duration], ...
	'ydata', [0, (m / n) * clip.event.duration], ...
	'tag', 'DELETE_ME' ...
); 

if (strcmp(get(get(tmp,'parent'),'visible'),'off'))
	set(tmp,'visible','off');
end

%--
% set colormap
%--

% NOTE: neither of these display options is very good

if (param.mask && param.mask_percentile)
	try
		cmap_real;
	end
else
	colormap(flipud(gray));
	try
		cmap_scale;		
	end	
end

%--
% update axes properties to handle image changing size
%--

set(ax, ...
	'layer', 'top', ...
	'box', 'on', ...
	'dataaspectratio', ones(1,3), ...
	'xlim', [0, clip.event.duration], ... 
	'ylim', [0, (m / n) * clip.event.duration], ...
	'xtick', [], ...
	'ytick', [], ...
	'yaxislocation', 'right' ...
);

%------------------------------------
% CREATE CONTEXT MENU
%------------------------------------

%--
% attach context menu if needed, clear in other case
%--

if isempty(get(ax, 'uicontextmenu'))
	top = uicontextmenu; set(ax, 'uicontextmenu', top);
else
	top = get(ax, 'uicontextmenu'); delete(allchild(top));
end
	
%--
% create clip menus
%--

g = [];

g(end + 1) = uimenu(top, ...
	'label', 'Clip' ...
);

g(end + 1) = uimenu(top, ...
	'label', 'Play Clip', ...
	'separator', 'on', ...
	'callback',{@play_clip_callback, pal} ...
);

g(end + 1) = uimenu(top, ...
	'label', 'Delete Clip', ...
	'callback',{@delete_clip_callback, pal} ...
);

%--
% create clip information menus
%--

[time, freq] = selection_labels(get_palette_parent(pal), clip.event);

L = { ...
	['Duration:  ', time{3}], ...
	['Min Freq:  ', freq{1}], ...
	['Max Freq:  ', freq{2}], ...
	['Bandwidth:  ', freq{3}] ...
	['Sampling Rate:  ', int2str(clip.samplerate), ' Hz'], ...
};

n = length(L);

S = bin2str(zeros(1, n)); S{2} = 'on'; S{end} = 'on';

g = menu_group(g(1), '', L, S);



function play_clip_callback(obj, eventdata, pal)

play_clip(pal);


function delete_clip_callback(obj, eventdata, pal)

delete_clip(pal);
