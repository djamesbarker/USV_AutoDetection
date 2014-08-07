function flag = str_to_file(str,f)

% str_to_file - put string into text file
% ---------------------------------------
%
% flag = str_to_file(str,f)
%
% Input:
% ------
%  str - fprintf string
%  f - file handle or file name
%
% Output:
% -------
%  flag - write success flag

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

% TODO: this is an awful function and should be rewritten from scratch

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1.2 $
% $Date: 2004-03-25 20:39:53-05 $
%--------------------------------

%-------------------------------------
% OPEN FILE
%-------------------------------------

%--
% set success flag
%--

flag = 1;

%--
% file name or file handle
%--

if (isstr(f))
	
	fid = fopen(f,'wt');
	
	if (fid == -1)
		flag = 0;
		disp(' ');
		error(['Error opening file ' f]);
	end
	
	name = 1;
	
else
	
	fid = f; name = 0;
	
end

%-------------------------------------
% HANDLE SPECIAL CHARACTERS
%-------------------------------------

%--
% new line to question mark
%--

str = strrep(str,'\n','$$'); 

%--
% two string new lines prefixed or suffixed escaped
%--

str = strrep(str,'$$$$''','\\n\\n'''); 

str = strrep(str,'''$$$$','''\\n\\n');

%--
% string new line prefixed or suffixed escaped
%--
 
str = strrep(str,'$$''','\\n''');

str = strrep(str,'''$$','''\\n');

str = strrep(str,'$$$$','\n$$');

str = strrep(str,'%','%%');

%-------------------------------------
% WRITE FILE
%-------------------------------------

while (~isempty(str))
	
	[tok,str] = strtok(str,'$$');
	
	fprintf(fid,[tok '\n']);
	
end
		
%-------------------------------------
% CLOSE FILE
%-------------------------------------

if (name)
	fclose(fid);
end


