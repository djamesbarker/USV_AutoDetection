function g = text_menu(h, opt)

% text_menu - create menu to control text properties of figure
% ------------------------------------------------------------
%
% opt = text_menu
%
%   g = text_menu(h, opt)
%
% Input:
% ------
%  h - handle to parent of text menu
%  opt - text menu options
%
% Output:
% -------
%  opt - default text menu options
%  g - handle to parent text menu

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
% $Revision: 1434 $
% $Date: 2005-08-03 17:17:51 -0400 (Wed, 03 Aug 2005) $
%--------------------------------

% TODO: add options to create only font or size menus, this impacts head label

%-------------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------------

%--
% set and possibly return default options
%--

if (nargin < 2) || isempty(opt)
	
	%---------------------------
	% MENU OPTIONS
	%---------------------------
	
	opt.font = 'simple'; % NOTE: allowed values are 'simple', 'full', and 'off'
	
	opt.size = 6:14; % NOTE: this is an integer sequence, or empty to turn menu off
	
	opt.accelerators = 1; % NOTE: this sets non-conflicting accelerators for the menus
	
	opt.head_label = 1; % NOTE: this produces a display of the current state in the parent label
	
	%---------------------------
	% CALLBACK OPTIONS
	%---------------------------
	
	% NOTE: these are the styles of uicontrol to affect
	
	opt.uicontrol = {'edit', 'listbox', 'popupmenu', 'pushbutton', 'text'};
	
	% NOTE: this determines whether we affect table and text objects
	
	opt.table = true; opt.text = false;
	
	%--
	% output options
	%--
	
	if ~nargin
		g = opt; return;
	end
	
end

%--
% handle multiple handles recursively
%--

if numel(h) > 1
	j = 1;
	
	for k = 1:length(h)
		out = text_menu(h(k) ,opt);
		
		if ~isempty(out)
			h(j) = out; j = j + 1;
		end
	end 
	
end

%--
% check input handle to be a suitable parent
%--

g = [];

if ~ishandle(h)
	warning('Input must be a parent handle.'); return;
end

type = get(h, 'type');

if ~(strcmp(type, 'figure') || strcmp(type, 'uimenu'))
	warning('Input must be a handle to a figure or menu.'); return;
end

%-------------------------------------------------------
% CREATE MENU
%-------------------------------------------------------

% NOTE: get parent figure in case parent is menu

h_fig = ancestor(h, 'figure');

set(h_fig, 'dockcontrols', 'off');

%--
% create main text control menus
%--

g = uimenu(h, 'label', 'Text');

if opt.head_label
	uimenu(g, 'label', ' ', 'tag', 'HEAD_LABEL');
end

g1 = uimenu(g, 'label', 'Font');

if opt.head_label
	set(g1, 'separator', 'on');
end

g2 = uimenu(g, 'label', 'Size');

%--
% get list of fonts
%--

switch opt.font
	
	case 'full'
		L = get_fonts;
		
	case 'simple'
		L = get_fonts(simple_fonts); 

	otherwise
		error(['Unrecognized fonts option ''', opt.font, '''.']);
		
end

%--
% create font menu
%--

t1 = uimenu(g1, ...
	'label', 'Previous Font', ...
	'callback', {@change_fontname, -1, opt} ...
);

t2 = uimenu(g1, ...
	'label', 'Next Font', ...
	'callback', {@change_fontname, 1, opt} ...
);

if opt.accelerators
	set_accelerator(t1, 'R', h_fig); set_accelerator(t2, 'T', h_fig);
end

for k = 1:length(L) 
	g3(k) = uimenu(g1, 'label', L{k}, 'callback', {@set_fontname, opt});
end 

set(g3(1), 'separator', 'on');

%--
% set list of sizes
%--

clear L;

for k = 1:length(opt.size)
	L{k} = int2str(opt.size(k));
end

%--
% create size menu
%--

t1 = uimenu(g2, ...
	'label', 'Increase', ...
	'callback', {@change_fontsize, 1, opt} ...
);

t2 = uimenu(g2, ...
	'label', 'Decrease', ...
	'callback', {@change_fontsize, -1, opt} ...
);

if opt.accelerators
	set_accelerator(t1, '=', h_fig); set_accelerator(t2, '-', h_fig);
end

for k = 1:length(L) 
	g4(k) = uimenu(g2, 'label', L{k}, 'callback', {@set_fontsize, opt});
end

set(g4(1), 'separator', 'on');

%--
% get and reflect text state
%--

% NOTE: state is not well defined until after calling menu

e = findobj(h_fig, 'style', 'edit');

if isempty(e)
	return;
else
	e = e(1);
end 

fn = get(e, 'fontname');

u1 = get(e, 'fontunits'); set(e, 'fontunits', 'points');

fs = get(e, 'fontsize'); set(e, 'fontunits', u1);

temp = get_menu(g3, fn);

if ~isempty(temp)
	set(temp, 'check', 'on');
end 

temp = get_menu(g4, int2str(fs));

if ~isempty(temp)
	set(temp, 'check', 'on');
end 

if opt.head_label
	update_head_label(h_fig, []);
end


%---------------------------------------------------
% IS_ACCELERATOR
%---------------------------------------------------

function test = is_accelerator(h, k)

test = 0;

g = findobj(h, 'type', 'uimenu');

if isempty(g)
	return;
end

if ~isempty(find(strcmpi(get(g, 'accelerator'), k)))
	test = 1;
end


%---------------------------------------------------
% SET_ACCELERATOR
%---------------------------------------------------

function flag = set_accelerator(g, k, h)

flag = 0;

if (nargin < 3) || isempty(h)
	h = ancestor(g, 'figure');
end

if ~is_accelerator(h, k)
	set(g, 'accelerator', k); flag = 1;
end


%---------------------------------------------------
% SET_FONTNAME
%---------------------------------------------------

function set_fontname(obj, eventdata, opt) %#ok<*INUSL>

%--
% update edit controls font
%--

h = ancestor(obj, 'figure');

% NOTE: we update uicontrols that have styles in the list

fontname = get(obj, 'label');

for k = 1:length(opt.uicontrol)
	
	g = findobj(h, 'style', opt.uicontrol{k});

	if ~isempty(g)
		set(g, 'fontname', fontname);
	end
end

if opt.text
	g = findobj(h, 'type', 'text');
	
	if ~isempty(g)
		set(g, 'fontname', fontname);
	end
end

if opt.table
	g = findobj(h, 'type', 'uitable');
	
	if ~isempty(g)
		set(g, 'fontname', fontname);
	end
end

%--
% update state display in menu
%--

sibs = get(get(obj, 'parent'), 'children');

set(sibs, 'check', 'off'); set(obj, 'check', 'on');

if opt.head_label
	update_head_label(obj)
end


%---------------------------------------------------
% SET_FONTSIZE
%---------------------------------------------------

function set_fontsize(obj, eventdata, opt)

value = eval(get(obj, 'label'));

%--
% update edit controls font
%--

% NOTE: we update uicontrols that have styles in the list

h = ancestor(obj, 'figure');

for k = 1:length(opt.uicontrol)
	
	g = findobj(h, 'style', opt.uicontrol{k});

	if ~isempty(g)
		u1 = get(g(1), 'fontunits'); set(g, 'fontunits', 'points');

		set(g, 'fontsize', value); set(g, 'fontunits', u1);
	end
end

if opt.text	
	g = findobj(h, 'type', 'text');
	
	if ~isempty(g)
		u1 = get(g(1), 'fontunits'); set(g, 'fontunits', 'points');

		set(g, 'fontsize', value); set(g, 'fontunits', u1);
	end
end

if opt.table
	g = findobj(h, 'type', 'uitable');
	
	% TODO: setting of table properties is in pixels, fix this
	
	if ~isempty(g)
		set(g, 'fontsize', value);
	end
end

%--
% update state display in menu
%--

sibs = get(get(obj, 'parent'), 'children');

set(sibs, 'check', 'off'); 

set(obj, 'check', 'on');

if opt.head_label
	update_head_label(obj)
end


%---------------------------------------------------
% CHANGE_FONTNAME
%---------------------------------------------------

function change_fontname(obj, eventdata, step, opt)

% NOTE: we only get options to pass on to set function

%--
% get siblings
%--

sibs = get(get(obj, 'parent'), 'children');

%--
% get menu with check
%--

ix = find(strcmp(get(sibs, 'check'), 'on'));

if ~isempty(ix)
	
	fontname = get(sibs(ix), 'label');
	
	S = simple_fonts;
	
	ix = find(strcmp(S, fontname));
	
	if (step > 0)
		if (ix + 1 <= length(S))
			fontname = S{ix + 1};
		else
			fontname = S{1};
		end
	else
		if (ix - 1 > 0)
			fontname = S{ix - 1};
		else
			fontname = S{end};
		end
	end
	
	g = findobj(sibs, 'label', fontname);
	
	%--
	% update fontname
	%--
	
	if ~isempty(g)
		set_fontname(g, [], opt);
	end
	
end


%---------------------------------------------------
% CHANGE_FONTSIZE
%---------------------------------------------------

function change_fontsize(obj, eventdata, step, opt)

% NOTE: we only get options to pass on to set function

%--
% get siblings
%--

sibs = get(get(obj, 'parent'), 'children');

%--
% get menu with check
%--

ix = find(strcmp(get(sibs, 'check'), 'on'));

if ~isempty(ix)
	
	fontsize = eval(get(sibs(ix), 'label'));
		
	if (step > 0)
		fontsize = int2str(fontsize + 1);
	else
		fontsize = int2str(fontsize - 1);
	end
	
	g = findobj(sibs, 'label', fontsize);
	
	%--
	% update fontsize
	%--
	
	if ~isempty(g)
		set_fontsize(g, [], opt);
	end
	
end


%---------------------------------------------------
% UPDATE_HEAD_LABEL
%---------------------------------------------------

function update_head_label(obj, eventdata)

%--
% get parent figure
%--

h = ancestor(obj, 'figure');

%--
% get label components and build label
%--

ch = get(get_menu(h, 'Font'), 'children');

fontname = get(findobj(ch, 'check', 'on'), 'label');

ch = get(get_menu(h, 'Size'), 'children');

fontsize = get(findobj(ch, 'check', 'on'), 'label');

label = [fontname, ' ', fontsize];

%--
% update label
%--

set(findobj(h, 'tag', 'HEAD_LABEL'), 'label', label);
