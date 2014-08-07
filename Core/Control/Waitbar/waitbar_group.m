function pal = waitbar_group(name, control, par, pos, opt)

% waitbar_group - create a waitbar group
% --------------------------------------
%
% pal = waitbar_group(name, control, par, pos, opt)
%
% opt = waitbar_group
%
% Input:
% ------
%  name - waitbar name
%  control - waitbar controls
%  par - waitbar parent (def: [])
%  pos - position with respect to parent
%  opt - waitbar options
%
% Output:
% -------
%  pal - waitbar handle
%  opt - default waitbar options

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

% TODO: create a simple PROGRESS waitbar when control array is empty

% TODO: attach update callback, so that we may simply call 'waitbar_update'

%--
% waitbar example code
%--

if ~nargin && ~nargout
	pal = three_waitbars; return;
end

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

%--
% set and possibly output options
%--

if (nargin < 5) || isempty(opt)
	
	%--
	% create and set default control group options for waitbar
	%--
	
	opt = control_group;

	opt.width = 18;

	opt.top = 0;

	opt.bottom = 1.75;

	opt.handle_to_callback = 1;

	%--
	% waitbar specific options
	%--

	opt.progress_header = 1;
	
	opt.update_rate = 0.05;

	opt.show_after = 0;
	
	%--
	% possibly return options
	%--
	
	if ~nargin
		pal = opt; return;
	end
	
end

%--
% update top margin considering header
%--

if opt.progress_header
	opt.top = 0;
else
	opt.top = 1.15;
end

%--
% set default position
%--

if (nargin < 4) || isempty(pos)
	pos = 'center';
end

%--
% set parent
%--

if (nargin < 3)
	par = [];
end

%--------------------------------------------------------------
% ADD PROGRESS HEADER
%--------------------------------------------------------------

if opt.progress_header
	
	header = control_create( ...
		'style', 'separator', ...
		'type', 'header', ...
		'string', 'Progress' ...
	);

else
	
	header = empty(control_create);

end

if isempty(control)
	
	control = control_create( ...
		'name', 'PROGRESS', ...
		'alias', 'Overall progress bar', ...
		'style', 'waitbar', ...
		'confirm', 1, ...
		'update_rate', [], ...
		'space', 2 ...
	);

end

control = [header, control];

%--------------------------------------------------------------
% CREATE WAITBAR
%--------------------------------------------------------------

% TODO: decide on how to create the bottom margin for the waitbar figure

%--
% create control group in new figure
%--

pal = control_group(par, '', name, control, opt);

%--
% set palette figure tag
%--

set(pal, ...
	'visible', 'off', ...
	'tag', ['XBAT_WAITBAR::' name] ...
);

%--
% set close request function
%--

%--
% tag progress header
%--

g = findobj(pal, 'tag', 'HEADER', 'string', 'Progress');

set(g, 'tag', 'PROGRESS_HEADER');

%--------------------------------------------------------------
% INITIALIZE DISPLAY
%--------------------------------------------------------------

%--
% initialize all waitbars to zero
%--

for k = 1:length(control)
	
	if strcmp(control(k).style, 'waitbar')
		waitbar_update(pal, control(k).name, 'value', 0);
	end
	
end

%--
% position waitbar
%--

if ~isempty(par)	
	position_palette(pal, par, pos);
end

%--
% display waitbar
%--

if (opt.show_after > 0)
	set(pal, 'visible', 'off'); return;
end

set(pal, 'visible', 'on'); drawnow;
	
