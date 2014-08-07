function [status, result, str] = scite(file)

% scite - use scite to edit file
% ------------------------------
%
% [status, result, str] = scite(file)
%
% Input:
% ------
%  file - file to edit
%
% Output:
% -------
%  status - status
%  result - result
%  str - command string

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

%--------------------
% SETUP
%--------------------

%--
% get tool
%--

tool = get_tool('Scite.exe');

if isempty(tool) && install_tool('SciTE', 'http://umn.dl.sourceforge.net/sourceforge/scintilla/wscite173.zip')
	
	tool = get_tool('Scite.exe');
	
end

%--------------------
% HANDLE INPUT
%--------------------

% TODO: this may be factored, it needs a name

if nargin

	%--
	% it is an error to use an unavailable tool
	%--
	
	if isempty(tool)
		error('Tool is not available.');
	end

else

	%--
	% output info or open scite
	%--

	if nargout
		status = tool;
	else
		if ~isempty(tool)
			system(['"', tool.file, '" &']);
		end
	end
	
	return;

end

%--
% find file
%--

% NOTE: this may not be the right thing to do

if isempty(strfind(file, filesep))
	file = which(file);
end

%--------------------
% OPEN
%--------------------

%--
% open file for editing
%--

% NOTE: we quote tool and file to avoid space problems

str = ['"', tool.file, '" "', file, '" &'];

[status, result] = system(str);

% NOTE: don't output when called as command

if ~nargout
	clear status;
end
