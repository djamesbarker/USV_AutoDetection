function [status, result] = tidy(file, config, varargin)

%--------------------
% SETUP
%--------------------

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

tool = get_tool('tidy.exe');

%--------------------
% HANDLE INPUT
%--------------------

if nargin

	% NOTE: it is an error to use an unavailable tool
	
	if isempty(tool)
		error('Tool is not available.');
	end

else

	% NOTE: output info or call tool

	if nargout
		status = tool;
	else
		if ~isempty(tool)
			system(['"', tool.file, '" &']);
		end
	end
	
	return;

end

if nargin < 2
	config = [];
end 

%--------------------
% TIDY
%--------------------

%--
% create options string
%--

options = ' ';

for k = 1:length(varargin)
	options = [options, varargin{k}, ' '];
end

%--
% create config string
%--

if isempty(config)
	config = ' ';
else
	config = [' -config "', which(config), '" '];
end

%--
% create and execute full command string
%--

str = ['"', tool.file, '"', options, config, '"', file, '"'];

str = strrep(str, '  ', ' ');

% NOTE: tidy modifies the file in-place

[status, result] = system(str);

result = file_readlines(result);

% NOTE: this only displays when it finds errors

if status > 1
	disp(result{1});
end
