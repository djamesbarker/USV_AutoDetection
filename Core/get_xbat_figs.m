function h = get_xbat_figs(varargin)

% get_xbat_figs - get handles to xbat figures
% -------------------------------------------
%
% h = get_xbat_figs
%
%   = get_xbat_figs('field', value, ...)
%
% Input:
% ------
%  field - field to select on ('type', 'parent', or 'child')
%  value - value of field
%
% Output:
% -------
%  h - selected figure handles

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

% TODO: make this code output the figure type and tag table

% TODO: make this function output parentage and children information

%------------------------------------
% ALLOWED FIELDS TABLE
%------------------------------------

persistent ALLOWED_FIELDS;

if isempty(ALLOWED_FIELDS)
	
	% NOTE: other get fields will be developed as needed
	
	ALLOWED_FIELDS = { ...
		'type', ...
		'parent', ...
		'child' ...
	};

end

%------------------------------------
% HANDLE INPUT
%------------------------------------

%--
% get field  value pairs or select all
%--

% NOTE: 'get_field_value' will produce an error on improper field value pair input

if length(varargin)	
	[field, value] = get_field_value(varargin, ALLOWED_FIELDS);
else
	field{1} = 'type'; value{1} = 'all';
end

%--
% check input values
%--

% NOTE: we ensure single handle input for 'parent' and 'child' based 'get'

ix = find(strcmp(field, 'parent'));

if ~isempty(ix)
	
	%--
	% check for single handle input
	%--
	
	if ~ishandle(value{ix}) || (length(value{ix}) > 1)
		error('Only single handle ''parent'' get is supported.');
	end
	
end

ix = find(strcmp(field, 'child'));

if ~isempty(ix)
	
	%--
	% check for single handle input
	%--
	
	if ~ishandle(value{ix}) || (length(value{ix}) > 1)
		error('Only single handle ''child'' get is supported.');
	end
	
end

%------------------------------------
% SET FIGURES TO SELECT FROM
%------------------------------------

%--
% get open figures if type is the first 'get' criterion
%--
	
g = get(0, 'children');

% NOTE: return empty on no figures

if isempty(g)
	h = []; return;
end

%------------------------------------
% SELECT FIGURES
%------------------------------------

h = g; 

%--
% select on all fields
%--

for k = 1:length(field)
	
	%--
	% consider selection type
	%--
	
	switch field{k}

		% NOTE: this selection rule relies on proper figure tags 
		
		case 'type', h = type_select(h, value{k});
		
		% NOTE: consider whether to implement as parent or child based 
		
		case 'parent', h = parent_select(h, value{k});
		
		% NOTE: this results in at most one figure handle
		
		case 'child', h = child_select(h, value{k});
			
	end
	
end


%---------------------------------------------------------
% TYPE_SELECT
%---------------------------------------------------------

function out = type_select(in, type)

% type_select - select figures based on type of figure
% ----------------------------------------------------
%
% out = type_select(in, type)
%
% Input:
% ------
%  in - figures to select from
%  type - type to select
%
% Output:
% -------
%  out - selected figures

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6789 $
% $Date: 2006-09-25 03:08:45 -0400 (Mon, 25 Sep 2006) $
%--------------------------------

%--
% return empty on empty
%--

if isempty(in)
	out = [];
end

%--
% select figures based on type
%--

switch lower(type)
	
	%------------------------------------
	% ALL XBAT FIGURES
	%------------------------------------
	
	case 'all'
		
		%--
		% set type tag prefix and length
		%--
		
		% TODO: these prefixes are hard coded throughout the system,
		% consider creating an access function
		
		% NOTE: the hard coded tags provide some readability to the code
		
		type = { ...
			'XBAT_SOUND_BROWSER', ...
			'XBAT_LOG_BROWSER', ...
			'XBAT_DATA_BROWSER', ...
			'XBAT_PALETTE', ...
			'XBAT_WAITBAR', ...
			'XBAT_WIDGET', ...
			'XBAT_EXPLAIN', ...
			'XBAT_SELECTION', ...
		};
	
		% NOTE: this can be done more efficiently
		
		out = [];
		
		for k = 1:length(type)
			
			tmp = match_tag_prefix(in, type{k}, 1);
			
			if ~isempty(tmp)
				out = [out; tmp];
			end
			
		end
		
	%------------------------------------
	% SOUND BROWSER FIGURES
	%------------------------------------
	
	case 'sound'
		
		out = match_tag_prefix(in, 'XBAT_SOUND_BROWSER', 1);
		
	%------------------------------------
	% LOG BROWSER FIGURES
	%------------------------------------
	
	case 'log'
		
		out = match_tag_prefix(in, 'XBAT_LOG_BROWSER', 1);
		
	%------------------------------------
	% DATA BROWSER FIGURES
	%------------------------------------
	
	case 'data'
		
		out = match_tag_prefix(in, 'XBAT_DATA_BROWSER', 1);
	
	%------------------------------------
	% PALETTES
	%------------------------------------
	
	case 'palette'
	
		out = match_tag_prefix(in, 'XBAT_PALETTE', 1);
		
	%--
	% BROWSER PALETTES
	%--
	
	case 'browser_palettes'
		
		out = match_tag_prefix(in, 'XBAT_PALETTE', 1);
		
		if isempty(out)
			return;
		end
		
		name = get(out, 'name');
		
		% NOTE: 'browser_palettes' outputs the list of browser palette names
		
		[ignore, ix] = intersect(name, browser_palettes);
		
		if isempty(ix)
			out = []; return;
		end
		
		out = out(ix);
		
	%--
	% EXTENSION PALETTES
	%--
	
	case 'extension_palettes'
		
		out = match_tag_prefix(in, 'XBAT_PALETTE', 1);
		
		if isempty(out)
			return;
		end
		
		name = get(out, 'name');
		
		% NOTE: 'browser_palettes' outputs the list of browser palette names
		
		[ignore, ix] = setdiff(name, browser_palettes);
		
		if isempty(ix)
			out = []; return;
		end
		
		out = out(ix);
		
	%------------------------------------
	% WAITBARS
	%------------------------------------
	
	case 'waitbar'
	
		out = match_tag_prefix(in, 'XBAT_WAITBAR', 1);
		
	%------------------------------------
	% WIDGET
	%------------------------------------
	
	case 'widget'
	
		out = match_tag_prefix(in, 'XBAT_WIDGET', 1);
		
	%------------------------------------
	% EXPLAIN
	%------------------------------------
	
	case 'explain'
	
		out = match_tag_prefix(in, 'XBAT_EXPLAIN', 1);
		
	case 'view'
	
		out = match_tag_prefix(in, 'XBAT_VIEW', 1);
		
	%------------------------------------
	% SELECTION
	%------------------------------------
	
	case 'selection'
	
		out = match_tag_prefix(in, 'XBAT_SELECTION', 1);

	%--
	% unrecognized figure type
	%--
	
	otherwise
		
		error(['Unrecognized XBAT figure type ''', type, '''.']);
		
end


%---------------------------------------------------------
% PARENT_SELECT
%---------------------------------------------------------

function out = parent_select(in, par)

% parent_select - select figures based on parent
% ----------------------------------------------
%
% out = parent_select(in, par)
%
% Input:
% ------
%  in - potential children
%  par - parent
%
% Output:
% -------
%  out - children

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6789 $
% $Date: 2006-09-25 03:08:45 -0400 (Mon, 25 Sep 2006) $
%--------------------------------

% NOTE: we could also check the parent fields of the registered figures

%--
% get parent recognized children
%--

data = get(par, 'userdata');

try
	out = [data.browser.palettes(:)', data.browser.children(:)'];
catch
	out = [];
end

%--
% consider inputs that are recognized
%--

out = intersect(in, out);

%--
% add neglected children to output
%--

% NOTE: these figures declare a parent even though they are not registered

for k = 1:length(in)
	
	%--
	% try to get parent from potential child
	%--
	
	data = get(in(k), 'userdata');
	
	try
		par2 = data.parent;
	catch
		try
			par2 = data.browser.parent;
		catch
			continue;
		end
	end
	
	%--
	% add neglected child to list of children
	%--
	
	if (par == par2)
		out(end + 1) = in(k);
	end
	
end

%--
% we probably have added duplicates return unique values
%--

out = unique(out);


%---------------------------------------------------------
% CHILD_SELECT
%---------------------------------------------------------

function out = child_select(in, child)

% child_select - select figure based on child
% -------------------------------------------
%
% out = child_select(in, child)
%
% Input:
% ------
%  in - figures to select from
%  child - child figure
%
% Output:
% -------
%  out - selected figures

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6789 $
% $Date: 2006-09-25 03:08:45 -0400 (Mon, 25 Sep 2006) $
%--------------------------------

%--
% get child registered parent
%--

data = get(child, 'userdata');

% TODO: there are two places where this information is stored, change this

try
	out = data.parent;
catch
	try 
		out = data.browser.parent;
	catch
		out = [];
	end
end

