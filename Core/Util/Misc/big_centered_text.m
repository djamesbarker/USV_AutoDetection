function handle = big_centered_text(par, string)

% big_centered_text - display big text centered on axes
% -----------------------------------------------------
%
% handle = big_centered_text(par, string)
%
% Input:
% ------
%  par - parent axes 
%  string - display string
%
% Output:
% -------
%  handle - text handle

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

% TODO: add display options

% TODO: develop display with axes and figure parent

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% check parent input
%--

if ~ishandle(par) || (~strcmp(get(par, 'type'), 'axes') && (nargin > 1))
	error('Parent input for display must be axes handle.');
end

%--
% get handles to big text display
%--

% NOTE: ensure singleton condition for figure

text1 = findobj(ancestor(par, 'figure'), 'tag', 'BIG_CENTERED_TEXT');

if length(text1) > 1
	delete(text1(2:end)); text1 = text1(1);
end

text2 = findobj(ancestor(par, 'figure'), 'tag', 'BIG_CENTERED_HIGHLIGHT');

if length(text2) > 1
	delete(text2(2:end)); text2 = text2(1);
end

% NOTE: return handle for no further input

if nargin < 2
	handle = [text1, text2]; return;
end

%---------------------------
% SET TEXT
%---------------------------

%--
% compute axes center
%--

x = 0.5 * sum(get(par, 'xlim')); y = 0.5 * sum(get(par, 'ylim'));

%--
% set string properties
%--

if isempty(text1)
	text1 = text(x, y, string); 
end

if isempty(text2)
	text2 = text(x, y, string); 
end

% TEST CODE: compute highlight text offset in pixels

pos = get_size_in(par, 'pixels'); xlim = get(par, 'xlim'); ylim = get(par, 'ylim');

offx = 2 * diff(xlim) / pos(3); offy = 2 * diff(ylim) / pos(4);

set(text2, ...
	'parent', par, ...
	'fontsize', 24, ...
	'horizontalalignment', 'center', ...
	'position', [x + offx, y - offy, 0], ...
	'string', string, ...	
	'color', 0.9 * [1 1 1], ...
	'tag', 'BIG_CENTERED_HIGHLIGHT' ...
);


set(text1, ...
	'parent', par, ...
	'fontsize', 24, ...
	'horizontalalignment', 'center', ...
	'position', [x, y, 0], ...
	'string', string, ...
	'color', [0 0 0], ...
	'tag', 'BIG_CENTERED_TEXT' ...
);

uistack(text1, 'top');

handle = [text1, text2];

