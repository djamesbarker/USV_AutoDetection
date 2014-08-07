function [control,pal,par] = get_callback_context(obj, mode)

% get_callback_context - get control callback context information 
% ---------------------------------------------------------------
%
% [control,pal,par] = get_callback_context(obj)
%
%          callback = get_callback_context(obj, 'pack')
%
% Input:
% ------
%  obj - callback object
%
% Output:
% -------
%  control - name and object handles associated to control
%  pal - control parent name and handle
%  par - palette parent tag and handle
%  callback - all outputs packed into a structure

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
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

% NOTE: this utility function is typically used at the start of callbacks

% NOTE: the outputs go from proximate to distal

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% set default mode to empty (no packing)
%--

if (nargin < 2)
	mode = '';
end

%----------------------------------------
% GET CONTEXT
%----------------------------------------

%--
% get control parent handle and name
%--

pal.handle = ancestor(obj, 'figure');

pal.name = get(pal.handle, 'name');

pal.tag = get(pal.handle, 'tag');

%--
% get control name and handles
%--

control.handle = obj;

control.name = get(obj, 'tag');

control.handles = findobj(pal.handle, 'tag', control.name);

%--
% get parent information if needed
%--

% NOTE: some might consider this information to be too intimate

flag = strcmp(mode, 'pack');

if (nargout > 2) || flag
	
	%--
	% get parent handle if possible
	%--
	
	try
		par.handle = get_field(get(pal.handle, 'userdata'), 'parent');
	catch
		par.handle = [];
	end
	
	%--
	% get parent tag if possible
	%--
	
	if ~isempty(par.handle)
		
		par.name  = get(par.handle, 'name'); 
		
		par.tag = get(par.handle, 'tag');
		
	else
		
		par.name = ''; par.tag = '';
		
	end
		
end

%--
% pack results if needed
%--

if flag
	
	%--
	% pack output into callback context
	%--
	
	callback.obj = obj; 
	
	% TODO: change the way this function is used to also get eventdata
	
% 	callback.eventdata = eventdata;
	
	callback.control = control;
	
	callback.pal = pal;
	
	callback.par = par;
	
	%--
	% output callback context
	%--
	
	control = callback;
	
end
