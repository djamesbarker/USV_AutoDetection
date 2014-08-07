function pos = position_palette(pal, par, opt, del)

% position_palette - position palette figure
% ------------------------------------------
%
% pos = position_palette(pal, par, opt)
%
% Input:
% ------
%  pal - palette figure handle (def: gcf)
%  par - parent figure handle (def: 0)
%  opt - position option (def: 'center')
%
% Output:
% -------
%  pos - final palette position

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
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

% TODO: make sure all positions are in pixels

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

% NOTE: these offsets are system dependent, these are typical values

% NOTE: this functionality is not revealed

if (nargin < 4) || isempty(del)
	del.x = 15; del.y = 10;
end

%--
% set default position option string
%--

% NOTE: allow for both string and integer positions

if (nargin < 3) || isempty(opt)
	opt = 'center';
end

%--
% convert position integer if needed
%--

persistent OPT_TABLE;

if ~ischar(opt)

	if isempty(OPT_TABLE)
		OPT_TABLE = { ...
			'right', ... 
			'right top', ...
			'right top corner', ...
			'top right', ...
			'top', ... 
			'top left', ...
			'left top corner', ...
			'left top', ...
			'left', ...
			'left bottom', ...
			'left bottom corner', ...
			'bottom left', ...
			'bottom', ...
			'bottom right', ... 
			'right bottom corner', ... 
			'right bottom', ...
			'center' ...
		};
	end
	
	%--
	% check position index
	%--
	
	if opt ~= round(opt)
		error('Position option index must be an integer.');
	end
	
	if (opt < 0) || (opt > (length(OPT_TABLE) - 1))
		error('Position option index must be in the integer range 0-16.');
	end
	
	%--
	% look up position option string in table
	%--
	
	opt = OPT_TABLE{opt + 1};

end

%--
% parse position option string
%--

opt = parse_opt(opt);
	
%--
% set default palette
%--

% NOTE: this can handle any type of figure not just palettes

if (nargin < 1) || isempty(pal)
	pal = gcf;
end

%--
% set parent
%--

% NOTE: figures without parent are placed relative to screen

if (nargin < 2) || isempty(par)
	
	try
		par = get_field(get(pal, 'userdata'), 'parent');
	catch
		par = 0;
	end
	
end

%-----------------------------------------
% GET INITIAL POSITIONS
%-----------------------------------------

%--
% get parent position
%--

if (par == 0)
	par_pos = get(par, 'screensize');
else
	par_pos = get(par, 'position');
end

%--
% get palette position
%--

pos = get(pal, 'position');

%-----------------------------------------
% COMPUTE SYSTEM OFFSETS
%-----------------------------------------

% CRP 20091106: modified scalar offsets
% to cause XBAT Palette to start below top of screen Windows menu

flag_menu_pal = has_menu(pal);

if flag_menu_pal
	pal_offset = 125 + del.y; % scalar was 55
else
	pal_offset = 35 + del.y;
end
	
flag_menu_par = has_menu(par);

if flag_menu_par
	par_offset = 125 + del.y; % scalar was 55
else
	par_offset = 35 + del.y;
end

%-----------------------------------------
% COMPUTE KEY PALETTE POSITIONS
%-----------------------------------------

%-----------------------------------------
% parent is figure
%-----------------------------------------

% TODO: develop a concept of figure spacing and apply it here

if (par ~= 0)

	%--
	% horizontal positions
	%--

	full_right = par_pos(1) + par_pos(3) + del.x;

	right = par_pos(1) + (par_pos(3) - pos(3));

	x_center = par_pos(1) + (par_pos(3) / 2) - (pos(3) / 2);

	left = par_pos(1);

	full_left = par_pos(1) - pos(3) - del.x;

	%--
	% vertical positions
	%--

	full_top = par_pos(2) + par_pos(4) + par_offset;

	top = par_pos(2) + (par_pos(4) - pos(4));

	y_center = par_pos(2) + ((3 * par_pos(4)) / 4) - pos(4);

	bottom = par_pos(2);

	full_bottom = par_pos(2) - pos(4) - pal_offset;
	
%-----------------------------------------
% parent is screen
%-----------------------------------------

% TODO: develop a concept of a screen margin and apply it here

else
	
	%--
	% horizontal positions
	%--

	full_right = par_pos(3) - pos(3) - del.x;

	right = full_right;

	x_center = (par_pos(3) / 2) - (pos(3) / 2);

	left = par_pos(1) + del.x;

	full_left = left;

	%--
	% vertical positions
	%--

	full_top = par_pos(4) - pos(4) - pal_offset + del.y;

	top = full_top;

	y_center = ((3 * par_pos(4)) / 4) - pos(4);

	bottom = par_pos(2) + 2 * del.y;

	full_bottom = bottom;
	
end

%-----------------------------------------
% COMPUTE PALETTE POSITION
%-----------------------------------------

switch length(opt)
	
	%-----------------------------------------
	% SIDE CENTERED POSITIONS
	%-----------------------------------------
	
	case 1
		
		switch opt{1}
			
			% NOTE: this is the current use of this function
			
			case 'center'
				pos(1) = x_center;
				pos(2) = y_center;
		
			case 'top'
				pos(1) = x_center;
				pos(2) = full_top;
				
			case 'right'
				pos(1) = full_right;
				pos(2) = y_center;
				
			case 'bottom'
				pos(1) = x_center;
				pos(2) = full_bottom;
				
			case 'left'
				pos(1) = full_left;
				pos(2) = y_center;
				
		end
		
	%-----------------------------------------
	% SIDE ALIGNED POSITIONS
	%-----------------------------------------
	
	case 2
		
		switch [opt{1},' ',opt{2}]
			
			case 'top left'
				pos(1) = left;
				pos(2) = full_top;
				
			case 'top right'
				pos(1) = right;
				pos(2) = full_top;
				
			case 'right top'
				pos(1) = full_right;
				pos(2) = top;
				
			case 'right bottom'
				pos(1) = full_right;
				pos(2) = bottom;
				
			case 'bottom left'
				pos(1) = left;
				pos(2) = full_bottom;
				
			case 'bottom right'
				pos(1) = right;
				pos(2) = full_bottom;
				
			case 'left top'
				pos(1) = full_left;
				pos(2) = top;
				
			case 'left bottom'
				pos(1) = full_left;
				pos(2) = bottom;
				
		end
		
	%-----------------------------------------
	% CORNER POSITIONS
	%-----------------------------------------

	case 3
		
		% NOTE: since the third token is always the same this is just a flag
		
		switch [opt{1},' ',opt{2}]
			
			case {'top left', 'left top'}
				pos(1) = full_left;
				pos(2) = full_top;
	
			case {'top right', 'right top'}
				pos(1) = full_right;
				pos(2) = full_top;
									
			case {'bottom left', 'left bottom'}
				pos(1) = full_left;
				pos(2) = full_bottom;
				
			case {'bottom right', 'right bottom'}
				pos(1) = full_right;
				pos(2) = full_bottom;
				
		end
		
end

%--
% bring parent and palette figures to front and update palette
%--

% NOTE: only position figure in the case of no output

if ~nargout
	
	if (par ~= 0)
		figure(par); 
	end

	figure(pal); set(pal, 'position', pos);
	
end


%-----------------------------------------------------
% PARSE_OPT
%-----------------------------------------------------

function opt = parse_opt(str)

% parse_opt - parse options string
% --------------------------------
%
% opt = parse_opt(str)
%
% Input:
% ------
%  str - options string
%
% Output:
% -------
%  opt - options string tokens

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%----------------------------------------------------
% PARSE TOKEN STRING
%----------------------------------------------------

% NOTE: we provide some flexibility by lowering the string here

str = lower(str);

[opt{1}, str] = strtok(str, ' ');

while ~isempty(str)
	[opt{end + 1}, str] = strtok(str, ' ');
end

%----------------------------------------------------
% VALIDATE TOKENS
%----------------------------------------------------

%--
% check number of tokens
%--

if (length(opt) > 3)
	error('Position option expressions may only contain three text tokens.');
end

%--
% check third token string if available
%--

if (length(opt) == 3) && ~strcmp(opt{3}, 'corner')
	error('Last position option token may only be ''corner''.');
end

%--
% check first two token strings
%--

TOK = {'top', 'right', 'bottom', 'left', 'center'};

if (length(opt) > 1)
	if isempty(find(strcmp(opt{2}, TOK)))
		error(['Position option token ''', opt{2}, ''' is not valid.']);
	end
end

if isempty(find(strcmp(opt{1}, TOK)))
	error(['Position option token ''', opt{1}, ''' is not valid.']);
end


