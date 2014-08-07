function out = image_window_menu(h,str,flag)

% image_window_menu - track and arrange open windows
% ----------------------------------------------------
%
% image_window_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - info flag (def: '')
%
% Output:
% -------
%  out - command dependent output

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
% $Revision: 565 $
% $Date: 2005-02-21 08:29:01 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

%-------------------------------------------------
% INITIALIZATION
%-------------------------------------------------

%--
% set info output flag
%--

if ((nargin < 3) | isempty(flag))
	flag = 0;
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% set default output
%--

out = [];

%--
% get available palettes
%--

PAL = image_palettes;

for k = 1:length(PAL);
	PAL{k} = strrep(PAL{k},'&','&&'); % NOTE: we need to escape ampersands in palette names
end

%-------------------------------------------------
% MAIN SWITCH
%-------------------------------------------------

switch (str)

%--------------------------------
% Initialize
%--------------------------------

case ('Initialize')
	
	%--
	% check for existing menu
	%--
	
	if (get_menu(h,'Window'))
		return;
	end
	
	%--
	% create window menu
	%--
		
	L = { ...
		'Window', ...
		'Cascade', ...
		'Arrange', ...
		'Tile', ...
		'Half Size', ...
		'Actual Size', ...
		'(Palettes)', ...
		PAL{:}, ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{5} = 'on';
	S{7} = 'on';
	
	A = cell(1,n);
	A{3} = 'R';
	A{2} = 'S';
	A{4} = 'T';
	
	g = menu_group(h,'image_window_menu',L,S,A);
	
	% NOTE: turn off palette header menu, this is just a label
	
	set(g(7),'enable','off');
	
%--------------------------------
% Arrange
%--------------------------------

case ('Arrange')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% return for single figure display
	%--
	
	if (length(IMAGE_FIGS) == 1)
		return;
	end
	
	%--
	% sort all windows using menu names (preserve relation order)
	%--
	
	[tmp,ix] = sort(NAME);
	
	IMAGE_FIGS = IMAGE_FIGS(ix);
	
	%--
	% tile windows
	%--

	figs_arrange(IMAGE_FIGS);

	%--
	% set display order of figures
	%--
	
	for k = 1:length(IMAGE_FIGS)
		tmp = get(IMAGE_FIGS(k),'position');
		pos(k) = tmp(1);
	end
	
	[tmp,ix] = sort(pos);
	
	for k = 1:length(IMAGE_FIGS)
		figure(IMAGE_FIGS(ix(k)));
	end
	
%--------------------------------
% Cascade
%--------------------------------

case ('Cascade')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% return for single figure display
	%--
	
	if (length(IMAGE_FIGS) == 1)
		return;
	end
	
	%--
	% sort all windows using menu names (preserve relation order)
	%--
	
	[tmp,ix] = sort(NAME);
	IMAGE_FIGS = IMAGE_FIGS(ix);
	
	%--
	% tile windows
	%--
	
	figs_cascade(IMAGE_FIGS);

	%--
	% set display order of figures
	%--
	
	for k = 1:length(IMAGE_FIGS)
		tmp = get(IMAGE_FIGS(k),'position');
		pos(k) = tmp(1);
	end
	
	[tmp,ix] = sort(pos);
	
	for k = 1:length(IMAGE_FIGS)
		figure(IMAGE_FIGS(ix(k)));
	end
	
%--------------------------------
% Tile
%--------------------------------

case ('Tile')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% return for single figure display
	%--
	
	if (length(IMAGE_FIGS) == 1)
		return;
	end
	
	%--
	% sort all windows using menu names (preserve relation order)
	%--
	
	[tmp,ix] = sort(NAME);
	IMAGE_FIGS = IMAGE_FIGS(ix);
	
	%--
	% tile windows
	%--
	
	figs_tile(IMAGE_FIGS);

%--------------------------------
% Half Size, Actual Size
%--------------------------------

case ({'Half Size','Actual Size'})
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	im = data.browser.images;
	
	%--
	% get desired scaling
	%--
	
	str = strtok(str,' ');
	
	%--
	% get initial figure position
	%--
	
	pos = get(h,'position');
		
	%--
	% compute according to desired scaling
	%--
	
	[m,n,d] = size(get(im(1),'cdata'));
	
	%--
	% scale the number of rows based on the page frequency settings
	%--
		
	if (~isempty(data.browser.page.freq))
		m = round(2 * m * diff(data.browser.page.freq) / data.browser.sound.samplerate);
	end
	
	% NOTE: 'truesize' may have to be rewritten from scratch
	
	% NOTE: consider computing the size along with the resize function
	
	switch (str)

		%--
		% HALF SIZE
		%--
		
		case ('Half')

			%--
			% produce actual size display
			%--

			for k = 1:8
				true_size(h,[m,n]);
			end

			%--
			% set figure to half the size
			%--

			tmp = get(h,'position');

			tmp(1:2) = pos(1:2);

			% NOTE: this consideration of the colorbar is awkward
			
			if (~isempty(data.browser.colorbar))
				tmp(3) = tmp(3) - 0.5 * (tmp(3) - (12 * 13));
			else
				tmp(3) = tmp(3) - 0.5 * (tmp(3) - (12 * 8));
			end

			tmp(4) = tmp(4) - 0.5 * (tmp(4) - (12 * (13 + length(data.browser.channels) - 1)));

			set(h,'position',tmp);

		%--
		% ACTUAL SIZE
		%--
		
		case ('Actual')

			for k = 1:8
				true_size(h,[m,n]);
			end
			
		%--
		% DOUBLE SIZE
		%--
		
		case ('Double')

			for k = 1:8
				true_size(h,[2*m,2*n]);
			end

	end

	%--
	% refresh figure and ensure we apply resize function
	%--
	
	refresh(gcf);
	
	browser_resizefcn(h,data);
	
	%--
	% set figure position to minimize motion upon scaling
	%--
	
	new_pos = get(h,'position');
	
	new_pos(1) = pos(1);
	new_pos(2) = pos(2) - (new_pos(4) - pos(4));
	
	set(h,'position',new_pos);
		
%--------------------------------
% Sound Browser Palette
%--------------------------------

case (PAL)
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	% handle escaped ampersands in palette name strings
	
	str = strrep(str,'&&','&');
	
	[out,flag] = image_palettes(h,str);
	
	% when browser palettes outputs a negative handle the palette already
	% existed and was just positioned

	%--
	% palette was recreated update last state if available
	%--
	
	if (flag)
		
		set(out,'visible','off');
		
		%--
		% update state of palette if available
		%--
		
		data = get(h,'userdata');
		
		if (~isempty(data.browser.palette_states))
			
			names = struct_field(data.browser.palette_states,'name');
			
			ix = find(strcmp(names,str));
			
			if (~isempty(ix))
				set_palette_state(out,data.browser.palette_states(ix));
			end
			
		end
		
		set(out,'visible','on');
		
	end
	
%--
% Rebuild Window menus
%--

otherwise
	
	image_window_menu;
	
end
	
	
