function handles = labelled_lines(ax,pos,label,opt)

% labelled_lines - create axes aligned labelled lines
% ---------------------------------------------------
%
% handles = labelled_lines(ax,pos,label,opt)
%
%     opt = labelled_lines
%
% Input:
% ------
%  ax - parent axes
%  pos - line positions
%  label - label contents
%  opt - display options
%
% Output:
% -------
%  opt - default display options
%  handles - handles to created lines and labels

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

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

% TODO: make the aligned axes an option

%--
% set default display options
%--

if (nargin < 4) || isempty(opt)
	
	opt.tag = 'LABELLED_LINES'; 
	
	opt.color = [1 0 0];
	
	opt.style = '--';
	
	opt.vertical = 'top';
	
	opt.horizontal = 'left';
	
	opt.enable = 0;
	
	%--
	% return options if needed
	%--
	
	if ~nargin
		handles = opt; return;
	end 
	
end

% NOTE: normalize tag to some extent

opt.tag = upper(strtrim(opt.tag));

%--
% handle labels and positions input
%--

if ~opt.enable || nargin < 3
	label = {};
end

if (~isempty(label) && (numel(pos) ~= numel(label)))
	error('Line positions and labels do not match in size.');
end

%--
% handle multiple axes recursively
%--

if (numel(ax) > 1)
	
	for k = 1:numel(ax)
		handles{k} = labelled_lines(ax(k),pos,label,opt);
	end
	
	return;
	
end

%----------------------------------------
% DISPLAY LINES
%----------------------------------------

%--
% set vertical positioning
%--

ylim = get(ax,'ylim'); height = diff(ylim); 

alpha = 0.1;

switch (opt.vertical)
	
	case ('top'), height = (1 - alpha) * height;
		
	case ('middle'), height = 0.5 * height;
		
	case ('bottom'), height = alpha * height;
	
	otherwise, error('Unrecognized label position option.');
		
end

baseline = opt.vertical;

%--
% compute horizontal offset
%--

prop = get(ax); aspect = prop.Position(4) / prop.Position(3); width = diff(prop.XLim);

offset = 0.25 * alpha * aspect * width;

switch (opt.horizontal)
	
	case ('left')
	
	case ('center'), offset = 0;
		
	case ('right'), offset = -offset;
		
	otherwise, error('unknown horizontal alignment');
		
end
		
align = opt.horizontal;

%--
% display labelled lines
%--

handles = [];

for k = 1:length(pos)
	
	%--
	% boundary lines
	%--
	
	handles(end + 1) = line( ...
		'parent',ax, ...
		'xdata',[pos(k), pos(k)], ...
		'ydata',ylim, ...
		'linestyle',opt.style, ...
		'color',opt.color, ...
		'hittest','off', ...
		'tag',[opt.tag, '_LINE'] ...
	);

	if isempty(label)
		continue;
	end

	%--
	% boundary label
	%--

	handles(end + 1) = text( ...
		'parent',ax, ...
		'string',label{k}, ...
		'position',[pos(k) + offset, height, 0], ...
		'verticalalignment',baseline, ...
		'horizontalalignment',align, ...
		'color',opt.color, ...
		'clipping','on', ...
		'tag',[opt.tag,'_LABEL'] ...
	);

	% NOTE: highlight fails when text is being deleted as we are doing this
	
	try
		text_highlight(handles(end));
	end
	
end
