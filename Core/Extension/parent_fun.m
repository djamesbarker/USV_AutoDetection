function [fun, par] = parent_fun

% parent_fun - get handle of equivalent parent function
% -----------------------------------------------------
%
% [fun, par] = parent_fun 
%
% Output:
% -------
%  fun - parent extension equivalent function handle
%  par - parent extension

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
% $Revision: 1752 $
% $Date: 2005-09-07 16:22:23 -0400 (Wed, 07 Sep 2005) $
%--------------------------------

% TODO: change name and create function to access simply container extension

fun = []; par = [];

%--
% get caller from stack
%--

stack = dbstack('-completenames');

% NOTE: return empty when called from the command line

if (length(stack) < 2)
	return;
end

caller = stack(2);

%--
% get extension type, name, and method from caller location
%--

% TODO: update code to use 'extensions_root' and other extension helpers

loc = path_to_cell(caller.file);

type = [loc{end - 3},' ',loc{end - 4}]; 

name = loc{end - 2};

method = file_ext(loc{end});

%--
% get extension and parent if possible
%--

ext = get_extensions(type, 'name', name);

% NOTE: return empty when extension has no parent extension

% db_disp parent-missing; type, name, ext

if isempty(ext.parent)
	return;
end

par = get_extensions(type, 'name', ext.parent.name);

%--
% get parent method
%--

fun = flatten_struct(par.fun);

fun = fun.(method);


% TODO: rename this or the public version of this function

function out = path_to_cell(str, delimiter)

% path_to_cell - separate path parts into cell
% --------------------------------------------
%
% out = path_to_cell(str)
%
% Input:
% ------
%  str - input string
%
% Output:
% -------
%  out - cell array with path contents

%--
% handle file separator
%--

if nargin < 2 || isempty(delimiter)

	if (strcmp(filesep,'\'))
		delimiter = '\\';
	else
		delimiter = filesep;
	end

end

%--
% parse string into cell
%--

out = strread(str, '%s', 'delimiter', delimiter);


