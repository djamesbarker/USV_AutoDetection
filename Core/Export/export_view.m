function view = export_view

% export_view - create export view structure
% ------------------------------------------
%
% view = export_view
%
% Output:
% -------
%  view - view structure, this function is call context dependent

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%--------------------------------
% SETUP
%--------------------------------

%--
% get caller
%--

caller = get_caller;

% NOTE: return on empty caller

if (isempty(caller))
	view = []; return;
end

%--
% get template files
%--

[par,leaf] = path_parts(caller.file);

template_root = [par, filesep, 'private'];

templates = get_field(what_ext(template_root,'m'),'m');

%--
% get template function handles
%--

init = pwd; cd(template_root);

if (isempty(templates))
	
	fun = [];
	
else
	
	% NOTE: consider making some noise when exception happens
	
	for k = 1:length(templates)
		try
			name = file_ext(templates{k}); fun.(name) = str2func(name);
		end
	end
	
end

cd (init);

%--------------------------------
% CREATE VIEW
%--------------------------------

view.name = caller.name;

view.fun = fun;


