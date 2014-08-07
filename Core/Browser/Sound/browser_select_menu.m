function flag = browser_select_menu(h,str,flag)

% browser_select_menu - browser event selection function menu
% -----------------------------------------------------------
%
% flag = browser_select_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag (def: '')
%
% Output:
% -------
%  flag - command execution flag

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
% $Date: 2005-08-25 10:08:55 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1680 $
%--------------------------------

%--
% enable some performace display
%--

PROFILE = get_env('xbat_profile');

if (isempty(PROFILE))
	set_env('xbat_profile',0);
	PROFILE = 0;
end

if (PROFILE)
	tic;
end

%--
% enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Select'))
		set(get_menu(h,str),'enable',flag);
	end			
	return;			
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% perform command sequence
%--

if (iscell(str))
	for k = 1:length(str)
		try
			browser_select_menu(h,str{k}); 
		catch
			disp(' '); 
			warning(['Unable to execute command ''' str{k} '''.']);
		end
	end
	return;
end

%--
% set handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% main switch
%--

switch (str)

%--
% Initialize
%--

case ('Initialize')
	
	%--
	% check for existing menu
	%--
		
% 	if (get_menu(h,'Select'))
% 		return;
% 	end

	%--
	% get userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% File
	%--
	
	L = { ...
		'Select', ...
		'All', ...	
		'Deselect', ...
		'Reselect', ...
		'Invert', ...
		'Save Selected ...' ...		
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{end} = 'on';
	
	A = cell(1,n);
	A{2} = 'A';
	
	tmp = menu_group(h,'browser_select_menu',L,S,A);
	data.browser.select_menu.select = tmp;
	
	set(tmp(1),'position',7);
	
	%--
	% save userdata
	%--
	
	set(gcf,'userdata',data);
	
%--
% 'All' and 'Select All'
%--

case ({'All','Select All'})
	
	%--
	% get userdata
	%--

	data = get(h,'userdata');
	
%--
% Deselect
%--

case ('Deselect')
	
%--
% Reselect
%--

case ('Reselect')
	
%--
% Invert
%--

case ('Invert')
	


end
	
%--
% display performance information
%--

if (PROFILE)	
	try
		t = toc;
		tmp = strrep(get(h,'name'),'  ',' ');
		tmp = tmp(2:end);
		sep = char(45*ones(1,length(tmp)));
		
		disp(tmp);
		disp(sep);
		disp([mfilename ' : ' str ' (time = ' num2str(t) ')']);
		disp(' ');
		disp(' ');
	end	
end
