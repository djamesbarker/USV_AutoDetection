function out = browser_svn_menu(h, str, flag)

% browser_svn_menu - browser subversion menu
% ------------------------------------------
%
% flag = browser_svn_menu(h, str, flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag (def: '')
%
% Output:
% -------
%  out - command dependent output

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
% $Date: 2005-07-22 18:51:17 -0400 (Fri, 22 Jul 2005) $
% $Revision: 1249 $
%--------------------------------

%-----------------------------
% SETUP
%-----------------------------

%--
% return empty by default
%--

out = [];

% NOTE: this feature is for xbat developers

if ~xbat_developer
	return;
end

%-----------------------------
% HANDLE INPUT
%-----------------------------

%--
% set info output flag
%--

if (nargin < 3) || isempty(flag)
	flag = 0;
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% set handle
%--

if (nargin < 1)
	h = gcf;
end

%--------------------------------
% COMMAND SWITCH
%--------------------------------

switch (str)

	%--
	% INITIALIZE
	%--
	
	case ('Initialize')

		%--
		% check for existing menu
		%--

		if get_menu(h, 'SVN')
			return;
		end

		%--
		% create menu
		%--

		L = { ...
			'SVN', ...
			'Update ...', ...
			'Status ...', ...
			'Commit ...', ...
			'About TSVN ...' ...
		};

		n = length(L); 
		
		S = bin2str(zeros(1,n)); S{3} = 'on'; S{end} = 'on';
		
		out = menu_group(h,'browser_svn_menu',L,S);
		
		if isempty(tsvn_root)
			set(out, 'enable', 'off');
		end

	%--
	% SVN COMMANDS
	%--
	
	otherwise

		%--
		% get actual command string
		%--
		
		[str, ignore] = strtok(str,' '); str = lower(str);
		
		
		%--
		% update xbat
		%--
		
		if strcmp(str, 'update')
			
			xbat_update; return;
		
		end
		
		%--
		% execute blocking subversion command with tortoise
		%--
		
		% NOTE: we block in case we update the svn info
		
		tsvn_options('block', 1);
				
		[status, result] = tsvn(str, xbat_root);
	
		% NOTE: non-zero status indicates premature termination, no need for update
	
		if status
			return;
		end
		
		%--
		% perform required updates
		%--
		
		% TODO: develop an update function to call after command

		% NOTE: this updates the 'svn_info' function to reflect current version
		
		if strcmp(str, 'commit')
			
			%--
			% update 'svn_info'
			%--
			
			get_svn_info('refresh');

			%--
			% update version display in browser windows
			%--
			
			h = get_xbat_figs('type', 'sound');

			for k = 1:length(h)
				set_browser_status_text(h(k), '', ['XBAT ', xbat_version]);
			end
			
		end

end
