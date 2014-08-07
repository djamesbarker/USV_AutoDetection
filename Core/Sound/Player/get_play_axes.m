function [ax, top] = get_play_axes(par, data)

% get_play_axes - get axes for play display
% -----------------------------------------
%
% [ax, top] = get_play_axes(par)
%
% Input:
% ------
%  par - player parent
%
% Output:
% -------
%  ax - play axes
%  top - top indicator

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

% TODO: generalize to get relevant axes, so we can produce a light update of other views

%------------------------
% HANDLE INPUT
%------------------------

%--
% check parent input
%--

if ~is_browser(par)
	error('Input parent handle is not browser handle.');
end

%--
% get parent state if needed
%--

if (nargin < 2)
	data = get_browser(par);
end

%------------------------
% GET DISPLAY AXES
%------------------------

%--
% get parent figures
%--

pars = par;

% TODO: create type list and iterate

fig = get_xbat_figs('parent', par, 'type', 'explain');

if ~isempty(fig)
	pars(end + 1) = fig;
end

fig = get_xbat_figs('parent', par, 'type', 'view');

if ~isempty(fig)
	pars(end + 1) = fig;
end

fig = get_xbat_figs('parent', par, 'type', 'selection');

if ~isempty(fig)
	pars(end + 1) = fig;
end

%--
% get play channels
%--

channel = unique(data.browser.play.channel);

%--
% get channel axes in parents and collect time and axes handle
%--

ax = []; top = [];

for i = 1:length(pars)
	
	for j = 1:length(channel)

		[ax2, top2] = get_channel_axes(pars(i), channel(j));

		for k = 1:length(ax2)
			ax(end + 1,:) = ax2(k); top(end + 1) = top2(k);
		end

	end
	
end


%---------------------------------------------
% GET_CHANNEL_AXES
%---------------------------------------------

function [ax, top] = get_channel_axes(par, ch)

%--
% convert channel to string
%--

ch = int2str(ch);

%--
% get all axes and corresponding tags
%--

ax = findobj(par, 'type', 'axes'); 

tag = get(ax, 'tag');

if ischar(tag)
	tag = {tag};
end

%--
% select axes with proper tag
%--

% NOTE: this should develop into something simpler and more reliable

for k = length(ax):-1:1
	
	if isempty(tag{k})
		ax(k) = []; continue;
	end 
	
	[tok1,tok2] = strtok(tag{k}, ' ');
	
	if isempty(tok2)
		tok = tok1;
	else
		tok = tok2;
	end
	
	if isempty(tok) || ~isequal(ch, strtrim(tok))
		ax(k) = []; continue;
	end
	
end

%--
% get topness of axes
%--

top = zeros(size(ax));

for k = 1:length(ax)
	
	if is_top(ax(k))
		top(k) = 1;
	end
	
end

%---------------------------------------------
% GET_OTHERS
%---------------------------------------------

function others = get_others(in, visible)

%--
% set default visible flag
%--

if (nargin < 2) || isempty(visible)
	visible = 1;
end

%--
% get other objects of same type possibly requiring visibility
%--

par = get(in, 'parent'); type = get(in, 'type');


if visible
	all = findobj(par, 'type', type, 'visible', 'on');
else
	all = findobj(par, 'type', type);
end

% HACK: this removes colorbar axes from other consideration, these were causing 'is_top' to fail

all = setdiff(all, findobj(par, 'tag', 'Colorbar'));

%--
% remove self from list
%--

others = setdiff(all, in);


%---------------------------------------------
% IS_TOP
%---------------------------------------------

function value = is_top(in)

value = 1;

%--
% get other visible objects 
%--

% TODO: add visible flag as input

others = get_others(in, 1);

if isempty(others)
	return;
end

%--
% compare positions
%--

pos = get(in, 'position'); pos = pos(2) + pos(4);

for k = 1:length(others)
	
	pos2 = get(others(k), 'position');
	
	if pos < (pos2(2) + pos2(4))
		value = 0; return;
	end
	
end


%---------------------------------------------
% IS_BOTTOM
%---------------------------------------------

function value = is_bottom(in)

value = 1;

%--
% get other visible objects 
%--

% TODO: add visible flag as input

others = get_others(in, 1);

if isempty(others)
	return;
end

%--
% compare positions
%--

pos = get(in, 'position'); pos = pos(2);

for k = 1:length(others)
	
	pos2 = get(others(k), 'position');
	
	if pos > pos2(2)
		value = 0; return;
	end
	
end
		
