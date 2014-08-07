function browser_template_menu(h,str,flag)

% browser_template_menu - browser template function menu
% -------------------------------------------------------
%
% flag = browser_template_menu(h,str,flag)
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
% $Date: 2005-08-25 10:08:38 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1654 $
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
	if (get_menu(h,'Template'))
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
			browser_template_menu(h,str{k}); 
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
% get available templates
%--

% get files in templates directory

fun = what('templates'); 
fun = fun.mat;

if (length(fun))
	
	% get template and name
	
	j = 1;
	for k = 1:length(fun)
		if findstr(fun{k},'_template')
			tmp = load(fun{k});
			TEMPLATE{j} = tmp.template;
			TEMPLATE_NAME{j} = tmp.name;
			j = j + 1;
		end
	end
	
	% sort templates according to names
	
	[TEMPLATE_NAME,ixs] = sort(TEMPLATE_NAME);
	
	TEMPLATE = TEMPLATE(ixs);

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
		
% 	if (get_menu(h,'Template'))
% 		return;
% 	end

	%--
	% get userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% Template
	%--
	
	L{1} = 'Template';
	L{2} = 'Active';
	
	for k = 1:length(TEMPLATE_NAME)
		L{k + 2} = [TEMPLATE_NAME{k} ' ...'];
	end
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	
	tmp = menu_group(h,'browser_template_menu',L,S);
	data.browser.measure_menu.measure = tmp;
	
	%--
	% View
	%--
	
	L = TEMPLATE_NAME;

	data.browser.measure_menu.view = ...
		menu_group(get_menu(tmp,'Active'),'browser_template_menu',L);
	
	%--
	% save userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Measurements
%--

case (TEMPLATE_NAME)
	
	%--
	% check for selected event and selected set
	%--
	
	%--
	% call measurement in interactive (parameter dialog mode)
	%--
	
	%--
	% update display
	%--
	
	
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
