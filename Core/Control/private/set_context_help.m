function handle = set_context_help(control,handles,opt)

% set_context_help - create help context menu to control
% ------------------------------------------------------
%
% handle = set_context_help(control,handles,opt)
%
% Input:
% ------
%  control - control 
%  handles - control handles
%  opt - palette options
%
% Output:
% -------
%  handle - created menu handle

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
% $Revision: 3399 $
% $Date: 2006-02-05 00:24:53 -0500 (Sun, 05 Feb 2006) $
%--------------------------------

%----------------------------------------
% SETUP
%----------------------------------------

%--
% consider style specific situations
%--

% FIXME: skip headers because they are not currently passing the handle to label text

% NOTE: store header text handles in 'label' and 'toggle' or get it here

switch (control.style)
	
	case ('separator')
		return;
		
	case ('tabs')
		return;	

end

%--
% select parent handle from available handles
%--

if (isstruct(handles))

	par = [];

	% NOTE: most controls have help on label

	if (isempty(par) && isfield(handles,'text'))
		par = handles.text;
	end

	% NOTE: checkbox contains a single checkbox object with label

	if (isempty(par) && isfield(handles,'checkbox'))
		par = handles.checkbox;
	end

	% NOTE: buttons typically have no label

	if (isempty(par) && isfield(handles,'button'))
		par = handles.button;
	end
	
	%--
	% return if no suitable parent was found
	%--

	if (isempty(par))
		handle = 0; return;
	end

%--
% parent handle was passed directly
%--
	
else
	
	par = handles; % NOTE: this is used in the recursive call
	
end

%--
% handle multiple parent input recursively
%--

% NOTE: this happens for grouped controls, currently only button groups

if (numel(par) > 1)
	
	handle = zeros(size(par));
	
	temp = control;
	
	for k = 1:numel(par)
		temp.name = control.name{k}; handle(k) = set_context_help(temp,par(k),opt);
	end
	
	return;

end

%----------------------------------------
% CREATE HELP MENU
%----------------------------------------

%--
% get context menu, label, and parent palette handle
%--

% NOTE: helper function creates and attaches context menu if needed

context = context_menu(par);

label = get_context_help_label(control,opt);

pal = ancestor(par,'figure');

%--
% append help menu to context menu
%--

handle = uimenu(context, ...
	'label', label, ...
	'callback', {@context_help_callback, pal, control} ...
);


%----------------------------------------------------------
% GET_CONTEXT_HELP_LABEL
%----------------------------------------------------------

% NOTE: this is the function that requires the palette options

function label = get_context_help_label(control,opt)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3399 $
% $Date: 2006-02-05 00:24:53 -0500 (Sun, 05 Feb 2006) $
%--------------------------------

%--
% get control label
%--

label = get_label(control,opt);

if (iscell(label))
	label = label{1};
end

%--
% prefix with tab label
%--

% TODO: consider skipping 'findstr' test if we use hierarchy indicator

if (~isempty(control.tab) && isempty(findstr(label,control.tab)))
	label = [control.tab, ' > ', label];
end

%--
% prepare help label
%--

% NOTE: we remove dialog indicating ellipsis from control label 

if (~isempty(label))
	label = ['''', strrep(label,' ...',''), ''' Help ...'];
else
	label = 'Help ...'; 
end


%----------------------------------------------------------
% CONTEXT_HELP_CALLBACK
%----------------------------------------------------------

function context_help_callback(obj,eventdata,pal,control)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3399 $
% $Date: 2006-02-05 00:24:53 -0500 (Sun, 05 Feb 2006) $
%--------------------------------

%--
% get palette info
%--

% NOTE: required palette info is stored in tag

info = parse_tag(get(pal,'tag'),[],{'type','subtype','name'});

type = lower(info.subtype); 

name = info.name;

%--
% generate link based on documentation convention and control info
%--

if (~isempty(control.help))
	type = 'direct';
end

switch (type)

	%--
	% direct link
	%--
	
	case ('direct')
		
		link = control.help;
		
	%--
	% conventional links
	%--
	
	% CORE PALETTE CONTROL
	
	case ('core')
		
		link = [xbat_root, filesep, 'Docs', filesep, name, '.html'];

	% EXTENSION PALETTE CONTROL
	
	otherwise

		ext = get_extensions(type,'name',name);
		
		link = [extension_root(ext), filesep, 'Docs', filesep, 'index.html'];

end

%--
% check for existence of file
%--

% TODO: display error or link to special page when help is not available

% TODO: this is not done check URL for file URL

if (~exist(link,'file'))
	return;
end

%--
% open link in browser
%--

web(link,'-browser');
