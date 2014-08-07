function pal = action_waitbar(context, duration)

% action_waitbar - create multiple target action waitbar
% ------------------------------------------------------
%
% pal = action_waitbar(context)
%
% Input:
% ------
%  context - action context
%  duration - duration of target in time
%
% Output:
% -------
%  pal - waitbar handle

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

%-----------------------------
% HANDLE INPUT
%-----------------------------

if nargin < 2
	duration = [];
end

%-----------------------------
% WAITBAR CONTROLS
%-----------------------------

%--
% progress waitbar
%--

control = control_create( ...
	'name', 'PROGRESS', ...
	'alias', 'Perform Action ...', ...
	'style', 'waitbar', ...
	'confirm', 1, ...
	'lines', 1.15, ...
	'space', 2 ...
);

% NOTE: this displays time realtime for sound actions

if ~isempty(duration)
	control.units = duration;
end

control(end + 1) = control_create( ...
	'name', 'close_after_completion', ... 
	'style', 'checkbox', ...
	'space', 0.75, ...
	'value', 0 ...
);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'string', 'Details' ...
);

control(end + 1) = control_create( ...
	'name', 'results', ...
	'alias', 'Results', ...
	'lines', 6, ...
	'space', 0, ...
	'confirm', 0, ...
	'style', 'listbox' ...
);

%-----------------------------
% CREATE WAITBAR
%-----------------------------

% TODO: put some string in here to indicate what we are doing

name = active_name(context);

opt = waitbar_group; % opt.show_after = 1;

pal = waitbar_group(name, control, [], [], opt);


%---------------------------
% ACTIVE_NAME
%---------------------------

function name = active_name(context)

%--
% declare special keywords to use when activating
%--

% NOTE: we capitalize to reduce hits

keyword = title_caps({'create', 'export', 'produce', 'extract', 'copy'});

preposition = {'to', 'from'};

name = context.ext.name; active = 0;

%--
% make name active
%--

for k = 1:length(keyword)
	if strfind(name, [keyword{k}, ' '])
		name = strrep(name, keyword{k}, string_ing(keyword{k})); active = 1;
	end
end

if ~active
	name = string_ing(name);
end

object = title_caps(string_plural(context.type));

%--
% check for preposition
%--

ix = [];

for k = 1:length(preposition)
   
    ix = regexp(name, ['\W', preposition{k}, '\W']);
    
    if ix
        name = [name(1:ix), object, ' ', name(ix + 1:end)]; break;
    end   
    
end

%--
% append object
%--

if isempty(ix)
    name = [name, ' ', object];
end

%--
% append elipses
%--

name = [name, ' ...'];
