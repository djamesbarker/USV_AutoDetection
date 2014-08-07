function g = profile_menu(fun,h)

% profile_menu - create menu with profile info for function
% ---------------------------------------------------------
%
% g = profile_menu(fun,h)
%
% Input:
% ------
%  fun - function name or handle
%  h - handle to parent of menu
%
% Output:
% -------
%  g - handles to created menus

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

% TODO: add reset and update menu

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% convert handle to string if needed
%--

if (isa(fun,'function_handle'))
	fun = func2str(fun);
end

%--
% create parent for menu if needed
%--

if (nargin < 2)
	h = fig; set(h,'name',fun); h = uimenu(h,'label','Profile'); 
end

%----------------------------------------
% CREATE MENU
%----------------------------------------

%--
% get profile info
%--

info = profile('info');

if (isempty(info))
	return;
end

table = info.FunctionTable;

%--
% select function info
%--

% NOTE: this is tricky since there are a variety of function types

% NOTE: for the moment simple functions are supported

names = {table.FunctionName}';

ix = find(strcmp(names,fun));

if (isempty(ix))
	return;
end

info_fun = table(ix);

%--
% remove undesired fields
%--

info_fun = rmfield(info_fun,{'CompleteName','ExecutedLines'});

if (isempty(info_fun.AcceleratorMessages))
	info_fun = rmfield(info_fun,{'AcceleratorMessages'});
end

%--
% remove children from matlab root and with no total time
%--

% NOTE: reconsider this later

root = [matlabroot, filesep, 'toolbox'];

for k = length(info_fun.Children):-1:1
	
	ix = info_fun.Children(k).Index;
		
	if (strmatch(root,table(ix).FileName))
		info_fun.Children(k) = []; continue;
	end
	
	if (info_fun.Children(k).TotalTime < eps)
		info_fun.Children(k) = []; continue;
	end
	
end

%--
% sort children according to descending total time
%--

total_time = cell2mat({info_fun.Children.TotalTime}');

[ignore,ix] = sort(total_time,1,'descend');

info_fun.Children = info_fun.Children(ix);

% TODO: find a way to select a relevant subset

% NOTE: select top 10 time spenders

if (length(info_fun.Children) > 10)
	info_fun.Children = info_fun.Children(1:10);
end 

%--
% update function info to be more informative
%--

fields = {'Parents','Children'};

for j = 1:length(fields)
	
	for k = 1:length(info_fun.(fields{j}))

		ix = info_fun.(fields{j})(k).Index;
		info_fun.(fields{j})(k).Index = table(ix).FunctionName;

	end
	
end

%--
% generate structure menu
%--

% NOTE: consider adding a callback associated to menu generation

% NOTE: for example, if the menu contains a file, show and or open

g = struct_menu(h,info_fun);
