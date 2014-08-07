function flag = browser_help_menu(h, str, flag)

% browser_help_menu - browser help function menu
% ----------------------------------------------
%
% flag = browser_help_menu(h, str, flag)
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
% $Date: 2005-08-25 10:08:44 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1663 $
%--------------------------------

%--
% set info output flag
%--

if (nargin < 3) || isempty(flag)
	flag = 0;
end

%--
% set command string
%--

if nargin < 2
	str = 'Initialize';
end

%--
% perform command sequence
%--

if iscell(str)
	
	for k = 1:length(str)
		try
			browser_help_menu(h, str{k}); 
		catch
			disp(['WARNING: Unable to execute command ''' str{k} '''.']);
		end
	end

	return;
	
end

%--
% set handle
%--

if nargin < 1
	h = gcf;
end

%--
% main switch
%--

switch str

%--
% Initialize
%--

case 'Initialize'
	
	%--
	% check for existing menu
	%--
		
	if get_menu(h, 'Help')
		return;
	end

	%--
	% get userdata
	%--
	
	data = get(h, 'userdata');
	
	L = { ...
		'Help', ...
		'Keyboard Shortcuts ...', ...
		'(XBAT.ORG)', ...
		'Home ...', ...
		'Docs ...', ...
		'Update ...', ...
		'About XBAT ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1, n));
	S{3} = 'on';
	S{end} = 'on';
	
	A = cell(1, n);
	A{2} = 'K';
	
	mg = menu_group(h, 'browser_help_menu', L, S, A);
	
	set(mg(3), 'enable', 'off');

	%--
	% update userdata
	%--
	
	data.browser.help_menu.help = mg;
	
	set(h, 'userdata', data);
		
%--
% Keyboard Shortcuts ...
%--

case 'Keyboard Shortcuts ...'

	%--
	% generate keyboard shortcut reference
	%--
	
% 	generate_key_reference;
	
	%--
	% display
	%--
	
	web([xbat_root, filesep, 'Docs', filesep, 'xbat-keys-category.html'], '-browser');

%--
% XBAT.ORG
%--

case 'Home ...', web('http://xbat.org/', '-browser');
	
case 'Docs ...', web('http://xbat.org/documentaion.html', '-browser');
	
case 'Update ...', xbat_update;
	
%--
% About XBAT ...
%--

case 'About XBAT ...', splash_image(select_splash, -1);

end
