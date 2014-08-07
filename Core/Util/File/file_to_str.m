function S = file_to_str(f,c)

% file_to_str - put text file into string
% ---------------------------------------
%
% S = file_to_str(f,c)
%
% Input:
% ------
%  f - file handle or file name
%  c - comment indicator (def: '')
%
% Output:
% -------
%  S - fprintf string for file

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

%--
% set comment indicator
%--

if (nargin < 2)
	c = '';
end

%--
% consider file name or file handle input
%--

if (ischar(f))

	% try to open file for text reading
	
	fid = fopen(f,'rt');
	
	if (fid == -1)
		warning(['Error opening file' f]);
		S = -1;
		return;
	end
	
	flag = 1;
	
else

	fid = f;
	
	% rewind file handle to get full file
	
	frewind(fid);
	
	flag = 0;
	
end

%--
% pack lines into fprintf string
%--

if (isempty(c))

	%--
	% initialize output string and line
	%--
	
	S = [];
	s = fgetl(fid);
	
	%--
	% add lines to output string
	%--
	
	while (ischar(s))
		S = [S s '\n'];
		s = fgetl(fid);		
	end
	
	S = [S '\n'];

%--
% remove comments and pack lines tightly into fprint string
%--

else
	
	%--
	% initialize output string and line
	%--
	
	S = [];
	s = fgetl(fid);
	
	%--
	% add non-comment lines to output string
	%--
	
	while (ischar(s))
		
		%--
		% skip comment line by getting another line
		%--
		
		if (isempty(s) | strcmp(c,s(1)))
			
			s = fgetl(fid);
			
		%--
		% add non-comment line to output string
		%--
		
		else
			
			% remove possible trailing comment from string (this may have
			% some problems when handling formatted string output
			% containing the comment indicator)
			
			[s,r] = strtok(s,c);
			
			if (length(s)) % if (any(isletter(s)))
				S = [S s '\n'];
			end
			
			s = fgetl(fid);
			
		end
		
	end
	
	S = [S '\n'];
	
	%--
	% pack output string by removing whitespace
	%--
	
	% this part of the processing is not clearly described as part of the
	% help. this may be another input option later
	
	% strip tabs from string
	
	S = strrep(S,'	','');
	
	% strip multiple line spaces
	
	T = '';
	
	while (length(T) ~= length(S))
		T = strrep(S,'\n\n','\n');
		S = T;
	end
	
end

%--
% close file input file
%--

if (flag)
	fclose(fid);
end
