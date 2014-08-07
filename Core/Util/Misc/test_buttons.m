function g = button_palette(h,fun,name,str,pad,color)

% button_palette - all button palette
% -----------------------------------
%
% g = button_palette(h,fun,name,str,pad,color)
%
% Input:
% ------
%  h - controlled or parent figure
%  fun - function handle for callbacks
%  name - name for palette 
%  str - button label strings
%  pad - button padding in tile units (def: 0.1)
%  color - color for palette header (def: [])
%
% Output:
% -------
%  g - palette figure handle

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
% $Date: 2004-06-27 15:38:36-04 $
% $Revision: 1.1 $
%--------------------------------

% NOTE: a much earlier version of the palettes used this approach

%--------------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------------

%--
% set default color
%--

if (nargin < 6)
	color = []; 
end

%--
% set default padding
%--

if ((nargin < 5) | isempty(pad))
	pad = 0.1
end

%--
% set default strings
%--

% NOTE: this is for testing, not real default

if ((nargin < 4) || isempty(str))
	
	% NOTE: an intended use of this type of palette is to access other palettes
	
	try
		str = browser_palettes;
	catch
		str = { ...
			'One', ... 
			'Two', ... 
			'Three', ...
			'Four', ... 
			'Five' ...
		};
	end

end 

%--
% set default name
%--

% NOTE: this is for testing, not real default

if ((nargin < 3) || isempty(name))
	name = 'Palettes';
end

%--
% set default callback
%--

% NOTE: this is for testing, not real default

if ((nargin < 2) | isempty(fun))
	fun = @default_callback;
end

if (~strcmp(class(fun),'function_handle'))
	disp(' ');
	error('Callbck function must be a function handle.');
end

%--
% set default controlled window 
%--

if (nargin < 1)
	h = []; 
end

%--------------------------------------------------------
% CREATE CONTROLS
%--------------------------------------------------------

%--
% create button palette header
%--

% NOTE: the space after the header is tweaked for better look

% if (pad > 0)
% 	if (pad < 1)
% 		space = 1.5 * pad;
% 	else
% 		space = pad;
% 	end
% else
% 	space = 0.05;
% end

space = 0.5;

control(1) = control_create( ...
	'style','separator', ...
	'type','header', ...
	'space',space, ...
	'string',name...
);

%--
% add color to header
%--

if (~isempty(color))
	control(1).color = color;
end

%--
% create button palette buttons
%--

% NOTE: name and alias should be used here somehow 

button = control_create( ...
	'style','buttongroup', ...
	'callback',fun, ...
	'lines',1.75, ...
	'space',pad ...
);

for k = 1:length(str)
	button.name = {str{k}};
	control(k + 1) = button; 
end

%--------------------------------------------------------
% CREATE BUTTON PALETTE
%--------------------------------------------------------

%--
% set control group options
%--

opt = control_group;

opt.width = 6;
opt.top = 0;
opt.left = 0.5;
opt.right = 0.5;
opt.bottom = max(0,(0.5 - pad));

%--
% create button palette
%--

% NOTE: for narrow palettes the figure title is not very useful

% NOTE: to use as palette the figure must be tagged

g = control_group(h,[],'',control,opt);

%--------------------------------------------------------
% DEFAULT_CALLBACK
%--------------------------------------------------------

function default_callback(obj,eventdata)

%--
% display button pressed string
%--

disp(' ');
disp(['BUTTON PRESSED: ''' get(obj,'string') '''']);

	
