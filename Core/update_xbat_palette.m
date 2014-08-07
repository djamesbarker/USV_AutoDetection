function update_xbat_palette

% update_xbat_palette - update available sounds and logs in palette
% -----------------------------------------------------------------

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--------------------------------------------------------------
% CHECK FOR PALETTE
%--------------------------------------------------------------

%--
% get main figure handle
%--

h = get_palette(0,'XBAT');

if (isempty(h))
	return;
end

%--------------------------------------------------------------
% UPDATE LIBRARIES
%--------------------------------------------------------------

%--
% check for libraries file
%--

str = [xbat_root 'data' filesep 'libraries.mat'];

if (exist(str) == 2)
	
	%--
	% get available libraries and active library
	%--
	
	load(str);
	
	active = get_active_library;
	
	%--
	% update library control
	%--
	
	g = findobj(h,'tag','Library','style','popupmenu');
	
	str = {'Default', library{:,1}};
	
	ix = find(strcmp(library(:,2),active));
	if (isempty(ix))
		ix = 1;
	else
		ix = ix + 1;
	end
	
	set(g, ...
		'string',str, ...
		'value',ix ...
	);
	
else
	
	%--
	% create libraries file
	%--
	
	library = cell(0,2);
	
	save(str,'library');
	
	%--
	% update library control
	%--
	
	g = findobj(h,'tag','Library','style','popupmenu');
	
	str = {'Default'};
	ix = 1;
	
	set(g, ...
		'string',str, ...
		'value',ix ...
	);
	
end

%--------------------------------------------------------------
% UPDATE SOUNDS
%--------------------------------------------------------------

%--
% get 'Sounds' control handle
%--

g = findobj(h,'tag','Sounds','style','listbox');

%--
% get sounds in library, directories correspond to sound files
%--

tmp = dir(get_active_library);

tmp = tmp(3:end); % remove dummy directory locations

j = 1;

file = cell(0);

for k = 1:length(tmp)
	
	if (tmp(k).isdir)
		file{j} = tmp(k).name;
		j = j + 1;
	end
	
end
	
if (isempty(file))
	
	%--
	% update control to no available sound files
	%--
	
	file{1} = '(No Available Sounds)';
	
	set(g,'string',file,'value',[]);
	
	%--
	% disable control
	%--
	
	control_update(0,'XBAT','Sounds','__DISABLE__');
		
else
	
	%--
	% update control to available sounds
	%--

	set(g,'string',sort(file),'value',[]);
	
	%--
	% enable control
	%--
	
	control_update(0,'XBAT','Sounds','__ENABLE__');
	
end

%--
% get 'Sound Info' control handles
%--

g = findobj(h,'tag','Sound Info','style','listbox');

set(g, ...
	'string',{}, ...
	'value',[] ...
);

%--------------------------------------------------------------
% UPDATE LOGS
%--------------------------------------------------------------
