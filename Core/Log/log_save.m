function flag = log_save(log,p,title)

% log_save - save log to file
% ---------------------------
%
% flag = log_save(log,p,title)
%
% Input:
% ------
%  X - log structure
%  p - alternate location to save, or dialog if empty
%  title - title string used in file dialog
%
% Output:
% -------
%  flag - save success indicator

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

%----------------------------------------------------
% HANDLE INPUT
%----------------------------------------------------

%--
% set title string
%--

if ((nargin < 3) || isempty(title))
	title = 'Save XBAT Log File:';
end

%--
% check for save as option
%--

if (nargin > 1)
	
	%--
	% get log location interactively using file dialog
	%--
	
	if (isempty(p))
		
		%--
		% start in input log directory
		%--
		
		di = pwd; cd(log.path);
		
		%--
		% get log file location and filename
		%--
		
     	[fn,p] = uiputfile(log.file,title);
		
		%--
        % return on cancel and return to initial directory
     	%--
		
        if (~fn)
			
			disp(' ');
			warning(['Log file ''' file_ext(log.file) ''' was not saved, ''uiputfile'' was cancelled.']);
			
			cd(di); 
			
			flag = 0; return;
			
		end
		
		%--
		% update log fields
		%--
		
		log.file = fn;
		
		log.path = p;
		
		log.created = datestr(now);
		
		log.modified = '';
		
		%--
		% save log
		%--
		
		flag = log_save(log);
		
	%--
	% log location and filename provided
	%--
	
	else
		
		%--
		% parse input location to match uigetfile output
		%--
        
        [p,f1,f2] = fileparts(p);
		
		fn = [f1 f2];
		
		%--
		% update log fields
		%--
		
		log.file = fn;
		
		log.path = p;
		
		log.created = datestr(now);
		
		log.modified = '';
		
		%--
		% save log
		%--
		
		flag = log_save(log);
		
	end
	
%--
% save log according to current field values
%--

else 

	%--
	% update saved field
	%--
	
	log.saved = 1;
	
	log.modified = datestr(now);
	
	%--
	% create named log variable
	%--
	
	var = file_ext(log.file);
	
	var = strip_punctuation(var);
	
	var = ['Log_' var];
    
    var = var(1:min(namelengthmax,length(var)));
	
	eval([var ' = log;']);
	
	%--
	% save log variable to log file
	%--
	
	% NOTE: convert single quotes to double quotes to evaluate string
	
	log_path = strrep(log.path,'''','''''');
	
	log_file = strrep(log.file,'''','''''');
	
	eval(['save(''' log_path, log_file ''',''' var ''');']);
	
	%--
	% return flag
	%--
	
	flag =  1;
	
end
