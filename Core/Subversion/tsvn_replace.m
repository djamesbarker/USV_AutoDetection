function [status, result] = tsvn_replace(work, in, out)

% tsvn_replace - use 'TortoiseSVN' helper application to perform string replacement
% ---------------------------------------------------------------------------------
%
% [status, result] = tsvn_replace(work, in, out)
%
% Input:
% ------
%  work - path to a subversion working copy
%  in - input file
%  out - output file
%
% Output:
% -------
%  status - system call status output
%  results - system call result output

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

%--
% check for svn installation
%--

if isempty(tsvn_root)
	status = 1; result = '''TortoiseSVN'' is not installed'; return;
end 

%--
% set persistent location of helper
%--

persistent TSVN_HELPER; 

if isempty(TSVN_HELPER)
	
	TSVN_HELPER = [tsvn_root, filesep, 'bin\SubWCRev.exe'];
	
	% NOTE: check whether the helper application exists
	
	if ~exist(TSVN_HELPER, 'file')
		
		error( ...
			'''TortoiseSVN'' must be installed for this command to be available.' ...
		); 
	
		TSVN_HELPER = '';
		
	end
	
end 

%--
% get full location of input file
%--

% NOTE: this file is assumed in the MATLAB path, also that 'which' is idempotent

in = which(in);

if isempty(in)
	return;
end

%--
% check output file input
%--

% NOTE: if out no 'filesep' assume same location as input

if isempty(findstr(out, filesep))
	[p, f] = path_parts(in); out = [p, filesep, out];
end

%--
% build command for and execute replacement operation
%--

cli_str = ['"', TSVN_HELPER, '" "', work, '" "', in, '" "', out, '"'];

% NOTE: this was here for some 'reason', possibly some network file thing

% cli_str = strrep(cli_str,'\','\\');

[status, result] = system(cli_str);
