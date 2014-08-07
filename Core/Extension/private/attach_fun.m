function fun = attach_fun(main, type)

% attach_fun - attach defined functions to extension
% --------------------------------------------------
%
% fun = attach_fun(main, type)
%
% Input:
% ------
%  main - handle to main extension function
%  
% NOTE: return empty function structure when main is not available

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

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

% NOTE: it is not clear what this exit condition means

if isempty(main)
	fun = clear_struct(feval(type)); return;
end

%----------------------------------------
% ATTACH FUNCTIONS
%----------------------------------------

%--
% get names of extension functions
%--

% NOTE: extension function names are computed from a flat fun structure

name = extension_signatures(type);

%--
% look for extension functions in private
%--

% NOTE: on read-only media, the extensions must have all their directories

root = create_dir([path_parts(which(func2str(main))), filesep, 'private']);

if isempty(root)
	error('Problem attaching extension function handles.');
end

curr = pwd; cd(root);

for k = 1:length(name)
			
	% NOTE: check for properly named file
	
	if ~exist([root, filesep, name{k}], 'file')
		handle{k} = []; continue;
	end
	
	% TODO: check function signature
	
	handle{k} = eval(['@', name{k}]);
	
end

cd(curr);

%--
% pack fun
%--

for k = 1:length(name)
	fun.(name{k}) = handle{k};
end

% NOTE: we unflatten this structure to get a proper fun structure

fun = unflatten_struct(fun);
