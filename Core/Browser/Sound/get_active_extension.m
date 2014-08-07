function [ext, ix, context] = get_active_extension(type, par, data)

% get_active_extension - get browser active detector
% -------------------------------------------------
%
% [ext, ix, context] = get_active_extension(type, par, data)
%
% Input:
% ------
%  type - extension type
%  par - parent browser
%  data - parent state
%
% Output:
% -------
%  ext - active detector extension
%  ix - index of extension in browser store
%  context - context

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

context = [];

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% check browser and get state if needed
%--

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

if (nargin < 4) || isempty(data)
	data = get_browser(par);
end

%--
% check extension type and existence of browser store for type
%--

if any(~ismember(type, get_extension_types))
	error(['Unrecognized extension type ''', type, '''.']);
end

%--
% handle multiple types recursively
%--

if iscellstr(type)
	
	% NOTE: the output structure for the recursive case is reasonable but quirky
	
	for k = 1:length(type)
		
		[ext, ix, context] = get_active_extension(type{k}, par, data);
		
		if ~isempty(ext)
			
			active.(type{k}).ext = ext; active.(type{k}).ix = ix; 
			
			active.(type{k}).context = context;
		
		end
		
	end
	
	if ~exist('active', 'var')
		active = [];
	end
	
	ext = active; ix = []; return;
	
end

%-------------------------
% GET ACTIVE EXTENSION
%-------------------------

%--
% consider trivial empty return conditions
%--

ix = [];

% NOTE: there is no browser registry for this extension type

if ~isfield(data.browser, type)
	ext = []; return;
end

% NOTE: there are no extensions of this type to make active

if isempty(data.browser.(type).ext)
	ext = []; return;
end 

%--
% get current active extension
%--

active = data.browser.(type).active;

% NOTE: there is no active extension of this type

if isempty(active)
	ext = []; return;
end 

if ischar(active)
	active = {active};
end

for k = 1:length(active)
	[ext(k), ix(k), context] = get_browser_extension(type, par, active{k}, data);
end

