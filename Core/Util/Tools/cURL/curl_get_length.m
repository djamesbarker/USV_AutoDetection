function [total, status, result] = curl_get_length(url, tool)

% curl_get_length - get context length for url
% --------------------------------------------
%
% total = curl_get_length(url, tool)
%
% Input:
% ------
%  url - to get length for
%  tool - curl tool
%
% Output:
% -------
%  total - url length in bytes

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

% NOTE: this indicates an indefinite wait

total = inf;

%--
% get curl tool
%--

if nargin < 2
	
	tool = get_curl;

	if isempty(tool)
		error('curl is not available.');
	end

end

%--
% get header
%--

[status, result] = system(['"', tool.file, '" -I ', url]);

if status
    return;
end

%--
% parse header to get total number of bytes
%--

parse = regexpi(result, 'content-length: (?<size>\d+)', 'names');

if isempty(parse)
	return;
end

total = str2double(parse.size);

