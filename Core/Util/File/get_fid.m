function [fid, name, flag] = get_fid(in, per)

% get_fid - get file identifier
% -----------------------------
%
% [fid, name, flag] = get_fid(in, per)
%
% Input:
% ------
%  in - file or file identifier
%  per - permissions requested
%
% Output:
% -------
%  fid - file identifier
%  name - file name
%  flag - file input indicator

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

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set default permission
%--

% NOTE: binary read is the current default file open behavior

if (nargin < 2) || isempty(per)
	per = 'rb';
end

%---------------------------------
% GET FILE IDENTIFIER
%---------------------------------

%--
% get input file identifier
%--

if ischar(in)
	
	%--
	% check that input file exists
	%--
	
	% NOTE: we only care when we mean to exclusively read from file
	
	if ~exist(in, 'file') && strcmp(per(1), 'r')
		error('Input file does not exist for reading.');
	end

	%--
	% try to open input file
	%--
	
	fid = fopen(in, per);

	if (fid == -1)
		error('Unable to open input file.');
	end
	
	%--
	% output requested values
	%--
	
	name = in; flag = 1;
	
else
	
	%--
	% check file identifier
	%--
	
	if is_fid(in)
		fid = in; 
	else
		error('File input must be path or file identifier.');
	end
	
	%--
	% get file name and check current permissions
	%--
		
	[name, cur] = fopen(fid);
		
	if ~strcmp(cur, per)
		error(['File permission must be set to ''', per, '''.']);
	end
	
	%--
	% ourput requested values
	%--
	
	flag = 0;
	
end

%--
% pack output into struct if needed
%--

if (nargout < 2)
	
	out.name = name; 
	
	out.fid = fid; 
	
	out.file = flag;
	
	fid = out;
	
end
