function [status, result] = curl_get(url, file, message)

% curl_get - get file using curl
% ------------------------------
%
% curl_get(url, file, message)
%
% Input:
% ------
%  url - source
%  file - destination
%  message - wait message

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

% NOTE: this function returns immediately, the download happens as a separate process

%-----------------
% SETUP
%-----------------

%--
% get curl tool
%--

tool = get_curl;

if isempty(tool)
	error('curl is not available.');
end

%-----------------
% HANDLE INPUT
%-----------------

%--
% set default file
%--

if (nargin < 2) || isempty(file)
	[p1, p2, p3] = fileparts(url); file = [p2, p3];
end

%--
% set default message
%--

if (nargin < 3) || isempty(message)
	message = ['Downloading ', file];
end

%-----------------
% GET
%-----------------

%--
% use curl to get size and fetch file
%--

% NOTE: this line avoids an overwrite warning

name = file; clear file;

file.name = name; 

% TODO: the message function may be a callback function

file.message = message;

[file.total, status, result] = curl_get_length(url, tool);

%--
% return if a problem occured.  This probably indicates a network failure of that the url is nolonger correct
%--

if status
    return;
end

str = ['"', tool.file, '" -o "', file.name, '" ', url, ' &'];

[status, result] = system(str);

% NOTE: this will never happen because of the '&'

if status
    return;
end

%--
% minimize console created by curl
%--

if ~isempty(nircmd)
	tool = nircmd; system(['"', tool.file, '" win min ititle "curl.exe"']);
end

%--
% create waitbar
%--

% TODO: this should take a type of 'curl' call input, say 'download' and 'upload'

curl_waitbar(file);
