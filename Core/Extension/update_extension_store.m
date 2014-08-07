function out = update_extension_store(in, types)

% update_extension_store - update browser extension store for types
% -----------------------------------------------------------------
%
%  par = update_extension_store(par, types)
%
% data = update_extension_store(data, types)
%
% Input:
% ------
%  par - handle
%  data - state
%  types - update types
%
% Output:
% -------
%  par - updated handle
%  data - updated state

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

% NOTE: consider if this function should update system extensions as well

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% set all types default
%--

if nargin < 2
	types = get_extension_types;
end 

if ischar(types)
	types = {types};
end

%--
% handle different input to get browser state
%--

% NOTE: we handle browser handle, or state input

if is_browser(in)
	data = get_browser(in);
else
	data = in;
end

%--
% get context
%--

context.sound = data.browser.sound;

context.user = get_active_user;

context.library = get_active_library;

%--
% update store for specific types
%--

for k = 1:numel(types)
	
	%--
	% normalize type
	%--
	
	type = type_norm(types{k});
	
	%--
	% get and initialize extensions of type
	%--

	exts = get_extensions(type);

	if ~isempty(exts)
		exts = extension_initialize(exts, context);
	end
	
	%--
	% update store
	%--
	
	% TODO: consider updating store, not recreating
	
	% NOTE: this destroys state for all extensions of type
	
	data.browser.(type).ext = exts;

	data.browser.(type).active = '';

end

%--
% update browser state
%--

% NOTE: update state for browser input, return updated state for state input

if is_browser(in)
	set(in, 'userdata', data); out = in;
else
	out = data;
end
