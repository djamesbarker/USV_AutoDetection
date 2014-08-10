function delete_clip(pal)

% delete_clip - delete clip from templates
% ----------------------------------------
%
% delete_clip(pal)
%
% Input:
% ------
%  pal - extension palette handle

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

% NOTE: most of this code will also be used to add templates

%---------------------
% UPDATE TEMPLATES
%---------------------

%--
% get control
%--

control = get_control(pal, 'templates');

%--
% delete clip and update fields
%--

templates = control.value;


if length(templates.clip) < 2
	
	set_control(pal, 'templates', 'value', []);
	
	set_control(pal, 'code', 'value', '');
	
	set_control(pal, 'template_mode', 'value', 1);
	
	handles = get_control(pal, 'template_select', 'handles');
	
	set(handles.obj, 'string', {'(No Templates Found)'}, 'value', 1);
	
	plot_clip(pal);
	
	return;
	
end

% templates

templates.clip(templates.ix) = [];

% current index

if (templates.ix > 1)
	templates.ix = templates.ix - 1;
end

% length

templates.length = length(templates.clip);

%--
% set control
%--

set_control(pal, 'templates', 'value', templates);

%---------------------
% UPDATE SELECT
%---------------------

%--
% update the template select control string considering the empty case
%--

if length(templates.clip)

	for k = 1:length(templates.clip)

		if ~isempty(templates.clip(k).code)
			L{k} = ['Clip ' int2str(k) ':  ' templates.clip(k).code];
		else
			L{k} = ['Clip ' int2str(k) ':  ( NO CODE )'];
		end

	end

	ix = templates.ix;

else

	L = {'(No Available Templates)'}; ix = 1;

end

%--
% get control handles and update
%--

handles = get_control(pal, 'template_select', 'handles');

set(handles.obj, ... 
	'string', L, 'value', ix ...
);

%-----------------------------
% UPDATE MODE AND CODE
%-----------------------------

clip = templates.clip(templates.ix);

set_control(pal, 'template_mode', 'value', clip.mode + 1);

set_control(pal, 'code', 'value', clip.code);


plot_clip(pal);


