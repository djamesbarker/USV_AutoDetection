function updated = add_gpl(file)

% add_gpl - add GPL preamble to file
% ----------------------------------
%
% updated = add_gpl(file)
%
% Input:
% ------
%  file - file
%
% Output:
% -------
%  updated - update indicator

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

updated = 0;

%--
% get file extension
%--

[p1, p2, ext] = fileparts(file);

if isempty(ext)
	return;
end

%--
% handle M files and C files
%--

switch ext
	
	case '.m'
		
		%--
		% read file, check for license, get license insertion point if needed
		%--
		
		lines = file_readlines(file);
		
		[skip, license] = has_gpl(lines);
		
		if skip	
			return;
		end
		
		ix = get_split_index(lines);
		
		if isempty(ix)
			
			str = ['Skipped <a href="matlab:edit(''', file, ''');">', strrep(file, xbat_root, '$XBAT_ROOT'), '</a>'];
			disp(str); return;
			
		end
		
		%--
		% write file with license
		%--
		
		out = get_fid(file, 'wt');
		
		file_process(out.fid, lines(1:ix));
		
		% TODO: license consists of copyright and license
		
		file_process(out.fid, license(2:end - 1));
		
		file_process(out.fid, lines(ix + 1:end));
		
		fclose(out.fid);
		
		updated = 1;
		
end


%---------------------------
% GET_SPLIT_INDEX
%---------------------------

function ix = get_split_index(lines)

%--
% empty file case
%--

if isempty(lines)
	ix = []; return;
end

%--
% script case
%--

% NOTE: we can place the license first for scripts

if ~strmatch('function', lines{1})
	ix = 1; return;
end

%--
% function case
%--

% NOTE: we try to add the license after the first comment block

ix = []; state = 0;

for k = 2:length(lines)
	
	if ~state 
		
		if isempty(lines{k})
			continue;
		end
		
		if lines{k}(1) == '%'
			state = 1; continue;
		end
		
		if ~all(isspace(lines{k}))
			return;
		end
		
	else

		if isempty(lines{k}) || (lines{k}(1) ~= '%')
			ix = k; return;
		end
		
	end
	
end


