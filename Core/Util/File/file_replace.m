function out = file_replace(in, pat, rep, out, opt)

% file_replace - find and replace multiple patterns in a file
% -----------------------------------------------------------
%
% opt = file_replace
%
% res = file_replace(in, pat, rep, out, opt)
%
% Input:
% ------
%  in - input file
%  pat - patterns to replace
%  rep - replacements
%  out - output file
%  opt - options
%
% Output:
% -------
%  opt - options
%  res - results
%
% NOTE: to understand replacement look at the replacement functions

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

%-------------------------------------------
% HANDLE INPUT
%-------------------------------------------

%--
% set and possibly output default options
%--

if (nargin < 5) || isempty(opt)
	
	% NOTE: test should be set to 0 when code is stable
	
	opt.regexp = 0; opt.verb = 1; opt.test = 1;

	if ~nargin
		out = opt; return;
	end
	
end

%--
% get helper functions based on options
%--

% TODO: update to use external 'line_replace' function

if opt.regexp
	fun.count = @regexp_count; fun.replace = @regexprep;
else
	fun.count = @strrep_count; fun.replace = @strrep;
end

%--
% set default output file
%--

if (nargin < 4) || isempty(out)
	out = in;
end

%--
% put patterns and replacement patterns in cell if needed
%--

if ischar(pat)
	pat = {pat};
end

if ischar(rep)
	rep = {rep};
end

%-------------------------------------------
% PROCESS FILE
%-------------------------------------------

%--
% read and process lines
%--

lines = file_readlines(in, {@line_replace, pat, rep, fun});

% NOTE: return empty results on empty lines

if isempty(lines)
	out = []; return;
end

%--
% write lines to temp file
%--

temp = temp_file(in);

info = file_writelines(temp, lines);

% NOTE: return empty on failure to write lines

if isempty(info)
	out = []; return;
end

%--
% copy temp file to output file and delete temp file
%--

% NOTE: we skip copy if this is a test

if ~opt.test
	copyfile(temp, out, 'f'); delete(temp); % NOTE: we try to force the file copy
end
	
%--
% output results
%--

% NOTE: we need the results structure for output or display

if nargout || opt.verb
	
	%--
	% pack replace results
	%--
	
	res.file = in; 
	
	res.pat = pat; 
	
	res.rep = rep;
	
	res.count = []; 
	
	res.lines = [];
	
	%--
	% output replace results
	%--
	
	out = res;
	
end

%--
% display results according to options
%--

display_results(res, opt);


%----------------------------------------------------------
% LINE_REPLACE
%----------------------------------------------------------

function line = line_replace(line, pat, rep, fun)

% line_replace - apply pattern replacements to line
% -------------------------------------------------
%
% line = line_replace(line, pat, rep, rep_fun)
%
% Input:
% ------
%  line - input line
%  pat - patterns to find
%  rep - replacement patterns
%  rep_fun - function to perform replacements
%
% Output:
% -------
%  line - line with replacements

%--
% loop over patterns
%--

for k = 1:length(pat)
	
	%--
	% count replacements in line
	%--
	
	count = fun.count(line, pat{k});
	
	%--
	% perform replacements if needed and update stores
	%--
		
	if count
		line = fun.replace(line, pat{k}, rep{k});
	end
	
end


%----------------------------------------------------------
% STRREP_COUNT
%----------------------------------------------------------

function count = strrep_count(line, pat)

% NOTE: find pattern in string and count number of starting points

count = length(strfind(line, pat));


%----------------------------------------------------------
% REGEXP_COUNT
%----------------------------------------------------------

function count = regexp_count(line, pat)

% NOTE: match regular expression and count the number of starting point indices

res = reg_exp(line, pat);

count = length(res.start);


%----------------------------------------------------------
% TEMP_FILE
%----------------------------------------------------------

function temp = temp_file(file)

% NOTE: prefix the filename with temp and put it in the temp directory

[ignore, file] = path_parts(file);

temp = [tempdir, 'temp_', file];


%----------------------------------------------------------
% DISPLAY_RESULTS
%----------------------------------------------------------

function display_results(res, opt)

% NOTE: options will provide finer control over this display

if opt.verb && res.count
	disp(' '); disp(sprintf(to_xml(res)));
end
