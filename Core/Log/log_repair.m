function [flag,str] = log_repair(p)

% log_repair - repair log file
% ----------------------------
%
% [flag,str] = log_repair(p)
%
% Input:
% ------
%  p - log file location (def: file dialog)
%
% Output:
% -------
%  flag - number of repairs
%  str - repair descriptions

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%-------------------------------------------------------------------
% SETUP
%-------------------------------------------------------------------

%--
% get file using uigetfile
%--

if ((nargin < 2) | isempty(p))
	
	%--
	% try to start in current log path
	%--
	
	p = get_env('xbat_path_log');
	pi = pwd;
	
	if (~isempty(p))
		
		%--
		% update current log path if previous current path fails
		%--
		
		try
			cd(p);
		catch
			set_env('xbat_path_log',pi);
		end
		
	end
	
	%--
	% select log to open for repairs
	%--
	
	[fn,p] = uigetfile2( ...
		{'*.mat','MAT-Files (*.mat)'; '*.*','All Files (*.*)'}, ...
		'Select XBAT Log File to Repair: ' ...
	);
	
	if (~fn)
		
		%--
		% return if repair was cancelled
		%--
		
		% return to initial directory
		
		cd(pi);
		
		% output empty repair count and report string
		
		flag = [];
		str = '';
		
		return;
		
	else
		
		%--
		% load log for repairs
		%--
		
		log = load([p,fn]);
		
		%--
		% update current log path and return to initial directory
		%--
		
		set_env('xbat_path_log',p);
		cd(pi);
		
	end
	
	%--
	% set interactive and report mode
	%--
	
	mode = 1;
	
else
	
	%--
	% load log for repairs
	%--
	
	log = load(p);	
	
	%--
	% set interactive and report mode
	%--
	
	mode = 0;
	
end

%-------------------------------------------------------------------
% REPAIR LOG
%-------------------------------------------------------------------

%--
% rename log variable
%--

tmp = fieldnames(log);	

eval(['log = log.' tmp{1} ';']);

%--
% initialize repair count and report string
%--

str = cell(0); % repairs report string

flag = 0; % repair count

%--------------------------------------
% check log open state
%--------------------------------------

if (log.open)
	
	%--
	% set log open state to closed
	%--
	
	log.open = 0;
	
	%--
	% update repair count and report string
	%--
	
	flag = flag + 1;
	str{flag} = '- Open state reset. (Medium)';
	
end

%--
% update path and file
%--

if (flag & (~strcmp(log.path,p) | ~strcmp(log.file,fn)))
	
	%--
	% update path and file (log has been renamed and/or moved
	%--
	
	log.path = p;
	log.file = fn;
	
	%--
	% update repair count and report string
	%--
	
	flag = flag + 1;
	str{flag} = '- Path and filename updated. (Low)';
	
end

%--
% remove empty or improper events
%--

del = 0; % deleted events count

for k = length(log.event):-1:1
	
	%--
	% remove event if channel fields are not set
	%--
	
	if (isempty(log.event(k).channel))
		log.event(k) = [];
		del = del + 1;
	end
	
end

%--
% update log length
%--

log.length = length(log.event);

if (del)
	len = length(msg);
	str{len + 1} = ['- ' int2str(cnt) ' improper events removed. (High)'];
end

%--
% save repairs to log file
%--

log_save(log);

%-------------------------------------------------------------------
% REPORT REPAIRS
%-------------------------------------------------------------------

%--
% report repair results if in interactive mode
%--

if (mode)
	
	if (flag)
		
		%--
		% repairs were needed
		%--
		
		head = ['Repairs were needed in ''' file_ext(log.file) ''':'];
		str = {head,str{:}};
		h = warn_dialog(str);
		waitfor(h);
		
	else
		
		%--
		% no repairs were needed
		%--
		
		h = help_dialog(['No repairs were needed in ''' file_ext(log.file) '''.']);
		waitfor(h);
		
	end
	
end
