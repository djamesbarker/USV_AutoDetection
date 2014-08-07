function [info, failed] = whosip(in, verb, wrap)

% whosip - use 'whosip' to get ip information
% -------------------------------------------
%
% [info, failed] = whosip(in, verb, wrap)
%
% Input:
% ------
%  in - list
%  verb - verbosity flag
%  wrap - wrap result in cell, otherwise we try to collapse to cell
%
% Output:
% -------
%  info - info
%  failed - lookup failed

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
% $Revision: 3232 $
% $Date: 2006-01-20 18:00:37 -0500 (Fri, 20 Jan 2006) $
%--------------------------------

% TODO: add caching and loading from cache, to avoid query

if nargin < 3
	wrap = 0;
end

if nargin < 2
	verb = 1;
end

%--
% get tool
%--

tool = get_tool('whosip.exe');

% NOTE: output tool if no input to process

if ~nargin
	info = tool; return;
end

%--
% handle missing tool
%--

if isempty(tool)
	error('Tool is not available.');
end
	
%--
% handle input
%--

if ischar(in)
	in = {in};
end

%--
% load cache
%--

cache = load_cache;

%--
% process addresses
%--

elapsed = []; info = {}; failed = {}; 

str = ['"', tool.file, '" __IP__'];

report(' ', verb);

for k = 1:length(in)

	%--
	% check for cached info
	%--
	
	cached = get_cache(cache, in{k});
	
	if ~isempty(cached)
		info{end + 1} = cached; report(['processing  ', in{k}, '\n'], verb); continue;
	end
	
	%--
	% get info from network
	%--
	
	report(['processing  ', in{k}], verb); 
	
	start = clock;
	
	[status, result] = system(strrep(str, '__IP__', in{k}));

	elapsed = etime(clock, start);
	
	%--
	% consider failure of get
	%--
	
	% NOTE: handle network failure
	
	if status
		failed{end + 1} = in{k}; report(['  (FAILED)\n'], verb); continue;
	end
	
	% NOTE: handle parse failure
	
	try
		info{end + 1} = parse_result(result); report(['  (', num2str(elapsed), 'sec)\n'], verb); info{end}
	catch
		failed{end + 1} = in{k}; report(['  (FAILED)\n'], verb); continue;
	end

	%--
	% cache result
	%--
	
	cache = set_cache(cache, info{end});
	
end

report(' ', verb);

if ~wrap
	try
		info = [info{:}]';
	catch

	end
end

%--
% save cache
%--

% NOTE: consider saving cache every few results, call this in the loop

save_cache(cache);


%-------------------------------
% REPORT
%-------------------------------

% NOTE: this wraps 'fprintf' to turn off display

function report(str, verb)

if nargin < 2
	verb = 1;
end

if ~verb
	return;
end 

fprintf(str);


%-------------------------------
% PARSE_RESULT
%-------------------------------

function info = parse_result(result)

opt = file_readlines; opt.skip = 1;

lines = file_readlines(result, [], opt);

info = struct;

for k = 1:length(lines)
	
	[field, value] = parse_line(lines{k});
	
	% NOTE: this means that the first value is admitted, result seems to have duplicate lines
	
	if ~isempty(field) && ~isfield(info, field)
		info.(field) = value;
	end
	
end


%-------------------------------
% PARSE_LINE
%-------------------------------

function [field, value] = parse_line(line)

[field, value] = strtok(line, ':');

field = lower(strrep(strtrim(field), ' ', '_')); value = strtrim(value(2:end));


%-------------------------------
% GET KEY
%-------------------------------

function key = get_key(ip)

key = ['IP', strrep(ip, '.', '__')];


%-------------------------------
% SET CACHE
%-------------------------------

function [cache, added] = set_cache(cache, info)

key = get_key(info.ip_address);

added = ~isfield(cache, key);

cache.(key) = info;


%-------------------------------
% GET CACHE
%-------------------------------

function info = get_cache(cache, ip)

key = get_key(ip);

if isfield(cache, key)
	info = cache.(key);
else
	info = [];
end


%-------------------------------
% CACHE FILE
%-------------------------------

function file = cache_file

file = [fileparts(mfilename('fullpath')), filesep, 'whosip_cache.mat'];

if ~exist(file, 'file')
	cache = struct; save(file, 'cache');
end


%-------------------------------
% LOAD CACHE
%-------------------------------

function cache = load_cache

% NOTE: this loads the cache variable 'that appears never to be set'

cache = []; load(cache_file);


%-------------------------------
% SAVE CACHE
%-------------------------------

function info = save_cache(cache)

save(cache_file, 'cache');

if nargout
	info = dir(cache_file);
end



