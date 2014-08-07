function views = get_views(root)

% get_views - get available export views
% --------------------------------------
%
% views = get_views(root)
%
% Input:
% ------
%  root - views root directory (def: views_root)
%
% Output:
% -------
%  views - available views

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
% HANDLE INPUT
%--------------------------------

%--
% get views root if needed
%--

if ((nargin < 1) || isempty(root))
	root = views_root;
end

%-----------------------------------
% GET VIEWS
%-----------------------------------

% TODO: implement persistent cache

%--
% get view directories
%--

dirs = get_field(what_ext(root),'dir');

%--
% evaluate constructors to get views
%--

views = []; 

init = pwd;

for k = 1:length(dirs)

	%--
	% move to view directory
	%--
	
	cd([root, filesep, dirs{k}]);
	
	%--
	% get valid function handle
	%--
	
	% NOTE: view name must nearly be a variable name
	
	name = lower(dirs{k});
	
	if (~isvarname(name))
		continue;
	end
	
	% NOTE: check that function handle points to actual function 
	
	fun = str2func(name);
		
	if (isempty(get_field(functions(fun),'file')))
		continue;
	end

	%--
	% evaluate constructor
	%--
	
	% NOTE: handle view evaluation failure
	
	try
		if (isempty(views))
			views = feval(fun);
		else
			views(end + 1) = feval(fun);
		end
	end

end

cd(init);
