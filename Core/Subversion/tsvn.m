function [status, result] = tsvn(str, p, varargin)

% tsvn - execute subversion client command
% ---------------------------------------
%
% [status, result] = tsvn(str, p, arg, ... , arg)
% 
% Input:
% ------
%  str - command string
%  p - path to working copy
%  arg - other arguments to command
%
% Output:
% -------
%  status - system call status output
%  results - system call results output
%
% ---------------------------------------
%
% NOTE: 'TortoiseSVN' must be installed for this command work
% 
% NOTE: use 'tsvn('help')' and to learn more about available commands

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

%------------------------------------------------------------
% SETUP
%------------------------------------------------------------

%--
% check for svn installation
%--

if isempty(tsvn_root)
	status = 1; result = '''TortoiseSVN'' is not installed'; return;
end 

%--
% set persistent location of tortoise subversion client
%--

persistent TSVN_CLIENT; 

if isempty(TSVN_CLIENT)
	
	TSVN_CLIENT = [tsvn_root, filesep, 'bin\TortoiseProc.exe'];
	
	% NOTE: check whether the client application exists
	
	if ~exist(TSVN_CLIENT, 'file')
		
		error( ...
			'''TortoiseSVN'' must be installed for this command to be available.' ...
		); 
	
		TSVN_CLIENT = '';
		
	end
	
end 

%--
% set persistent list of available commands
%--

persistent TSVN_COMMANDS;

if isempty(TSVN_COMMANDS)
	
	TSVN_COMMANDS = { ...
		'add', ...
		'about', ...
		'help', ...
		'settings', ...
		'blame', ...
		'commit', ...
		'copy', ...
		'diff', ... % NOTE: 'diff' used in this way compares input file to base
		'export', ...
		'log', ...
		'repobrowser', 'browser', ...
		'repostatus', 'status', ... 
		'revert', ...
		'checkout', ...
		'update', ...
		'update_to' ...
	}';

end

%--
% get svn options
%--

opt = tsvn_options;

%--
% build interaction string based on options
%--

if opt.close
	interact = '/closeonend:1';
else
	interact = '/closeonend:0';
end

% NOTE: non-blocking character is added when needed to completed command string

%------------------------------------------------------------
% HANDLE INPUT
%------------------------------------------------------------

%--
% output available command strings or set default command
%--

if (nargin < 1) || isempty(str)
	
	% NOTE: output requested on no command returns available commands
	
	if nargout
		status = TSVN_COMMANDS; return;
	else
		str = 'about';
	end

end

%--
% set default output
%--

status = []; result = '';

%--
% check provided command
%--

if ~ismember(str, TSVN_COMMANDS)
	error(['Unrecognized command ''', str, '''.']);
end

%--
% set default path
%--

if (nargin < 2) || isempty(p)
	p = pwd;
end

if ~is_working_copy(p)
	error('Input directory is not part of working copy.');
end

%------------------------------------------------------------
% BUILD AND EXECUTE COMMAND
%------------------------------------------------------------

% NOTE: the commands are available in the 'TortoiseSVN' documentation

%--
% put prefix to command string together
%--

cli_pre = ['"', TSVN_CLIENT, '" ', interact, ' -notempfile /command:'];

switch str
	
	%-----------------------------------------
	% BASIC SVN COMMANDS
	%-----------------------------------------

	% NOTE: version, help, and settings commands
	
	case { ...
		'about', ...
		'help', ...
		'settings' ...
	}

		cli_str = [cli_pre, str];
		
	%-----------------------------------------
	% BASIC WORKING COPY COMMANDS
	%-----------------------------------------
		
	% NOTE: these take a working copy path or a file in a working copy as argument

	case { ...
		'add', ...
		'blame', ...
		'commit', ...
		'copy', ...
		'diff', ... % NOTE: 'diff' used in this way compares input file to base
		'export', ...
		'log', ...
		'repobrowser','browser', ...
		'repostatus','status', ... 
		'revert' ...
	}

		% TODO: distinguish between directory and file path input

		% NOTE: calling 'diff' with a directory argument is the same as 'status'
		
		%--
		% replace shortcut commands with actual commands
		%--
		
		switch str
			
			case 'browser'
				str = 'repobrowser';
				
			case 'status'
				str = 'repostatus';
				
		end
		
		cli_str = [cli_pre, str, ' /path:"', p, '"'];
		
	%-----------------------------------------
	% COMPLEX WORKING COPY COMMANDS
	%-----------------------------------------
	
	% NOTE: these commands may take other arguments besides working copy path
	
	%-------------------
	% CHECKOUT
	%-------------------
	
	case 'checkout'
		
		cli_str = [cli_pre, str, ' /path:"', p, '" /url:"', varargin{1}, '"'];
		
		disp(cli_str); return;
		
	%-------------------
	% UPDATE
	%-------------------
	
	case { ...
		'update', ...
		'update_to' ...
	}
		
		
		%--
		% update to head revision
		%--
		
		cli_str = [cli_pre, 'update /path:"', p, '"'];
			
		%--
		% ask revision to update to
		%---
		
		if strcmp(str, 'update_to')
			cli_str = [cli_str, ' /rev'];
		end
		
end

%--
% make command non-blocking if needed
%--

% NOTE: the method is the same in both pc and unix machines

if ~opt.block
	cli_str = [cli_str, ' &'];
end

%--
% display and execute command
%--

% disp(' '); disp(cli_str);

[status, result] = system(cli_str);
		
