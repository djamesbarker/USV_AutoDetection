function [line, count] = line_replace(line, pat, rep, opt)

% line_replace - apply pattern replacements to line
% -------------------------------------------------
%
% line = line_replace(line, pat, rep, opt)
%
%  opt = line_replace
%
% Input:
% ------
%  line - input line
%  pat - pattern 
%  rep - replace
%  opt - replace options
%
% Output:
% -------
%  line - line with replacements
%  opt - default replace options

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

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% set and possibly return default replace options
%--

if (nargin < 4) || isempty(opt)
	
	% NOTE: valid values are 'strrep' and 'regexp'
	
	opt.mode = 'strrep';
		
	if ~nargin
		line = opt; return; 
	end

end

%--
% check pattern and replace input
%--

char_in = ischar(pat) && ischar(rep);

% NOTE: patterns and replacements are non-empty cell arrays of same length

cell_in = iscellstr(pat) && iscellstr(rep) && length(pat) && (length(pat) == length(rep));

if ~(char_in || cell_in)
	error('Input must consist character or string cell array patterns and replacements.');
end

%--------------------------------------
% PERFORM REPLACEMENTS
%--------------------------------------

%--
% set replace helpers based on type
%--

switch opt.mode
	
	case 'strrep'
		fun.count = @strrep_count; fun.replace = @strrep;
		
	case 'regexp'
		fun.count = @reg_exp; fun.replace = @reg_exp_count;

	otherwise
		error(['Unrecognized replace mode ''', opt.mode, '''.']);
		
end

%--
% loop over pattern array
%--

% NOTE: pattern order matters

count = 0;

for k = 1:length(pat)
	
	%--
	% count replacements if needed
	%--
	
	% NOTE: when count is cheap, zero count allows us to skip replace
	
	if nargout > 1
		count = count + fun.count(line, pat{k});
	else
		count = 1;
	end
	
	%--
	% perform replacements
	%--
		
	if count
		line = fun.replace(line, pat{k}, rep{k});
	end
	
end


%--------------------------------------
% STRREP_COUNT
%--------------------------------------

function count = strrep_count(line, pat)

% NOTE: find and count pattern occurences in string

count = length(strfind(line, pat));


%--------------------------------------
% REG_EXP_COUNT
%--------------------------------------

function count = reg_exp_count(line, pat)

% NOTE: match regular expression and count starting points

res = reg_exp(line, pat);

count = length(res.start);
