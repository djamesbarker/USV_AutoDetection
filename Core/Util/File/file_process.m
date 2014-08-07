function out = file_process(out, in, fun, opt)

% file_process - process file by lines
% ------------------------------------
%
% file_process(out, in, fun, opt)
%
% opt = file_process
%
% Input:
% ------
%  out - output file or file identifier
%  in - input file or file identifier
%  fun - fun to process each line
%  opt - options
%
% Output:
% -------
%  info - output file info
%  opt - options

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

% TODO: update callback handling code to use new callback framework

lastwarn('');

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set and possibly return default options
%--

if (nargin < 4) || isempty(opt)
	
	%--
	% create options struct
	%--
	
	opt.pre = ''; % input comment prefix, indicates skip comments
	
	opt.skip = 0; % skip empty lines indicator

	%--
	% possibly output options and return
	%--
	
	if ~nargin
		out = opt; return;
	end
	
end

%--
% set process function
%--

if (nargin < 3) || isempty(fun)
	fun = []; args = [];
else
	[fun, args] = parse_fun(fun);
end

%--
% check if processing function has state
%--

% NOTE: this requires the function to also take in state as second argument

has_state = ~isempty(fun) && (nargout(fun) > 1);

% NOTE: we pass an empty state for the first line as convention

if has_state
	state = [];
end

%--
% set collapse empty lines state
%--

collapse = 0;

%---------------------------------
% PROCESS LINES
%---------------------------------

% NOTE: reading and writing from line buffers is revealed through other functions

%--
% get output file identifier or initialize line buffer
%--

% NOTE: empty out stores output in line buffer

buff_out = isempty(out); 

if buff_out
	lines = {};
else
	out = get_fid(out, 'wt');
end

%--
% get input file identifier or rename input to lines buffer
%--

% TODO: make this an 'if' and test 'iscellstr'

switch class(in)
	
	%--
	% string cell array input
	%--
	
	% NOTE: string cell array input reads lines from line buffer
	
	case 'cell', buff_in = 1; buff_lines = in;
	
	%--
	% string input or file input
	%--
	
	case 'char'
		
		% NOTE: string buffer input is converted to cell array of strings
		
		if exist(in, 'file')
			buff_in = 0; in = get_fid(in, 'rt'); empty_count = 0;
		else		
			buff_in = 1; buff_lines = strread(in, '%s', -1, 'delimiter', '\n', 'whitespace', '')';
		end
		
end

if buff_in
	ix = 0; N = length(buff_lines);
end

%--
% iterate over input file lines
%--

while 1
	
	%--
	% get line from input file or line buffer
	%--
	
	if buff_in

		ix = ix + 1;

		if ix > N
			break;
		end

		line = buff_lines{ix};
		
	else
		
		% NOTE: this strips line termination

		line = fgetl(in.fid);

		if ~ischar(line)
			break;
		end

	end
	
	%--
	% skip or collapse empty input lines
	%--
		
	% NOTE: collapse multiple empty lines is not available
	
	switch opt.skip
		
		%--
		% skip empty input lines
		%--
		
		case 1
			
			if all(isspace(line))
				continue;
			end
	
		%--
		% collapse multiple empty input lines
		%--
		
		case -1
			
			if all(isspace(line))
				
				% NOTE: deal with blank line using collapse state
				
				if collapse
					continue;
				end
				
				% NOTE: output blank line and set to collapse

				if buff_out
					lines{end + 1} = line;
				else
					fprintf(out.fid, [line, '\n']);
				end

				collapse = 1; continue;

			end

	end
	
	%--
	% skip comment lines
	%--
	
	% NOTE: this does not strip end of line comments
	
	if ~isempty(opt.pre)
		
		trim_line = strtrim(line);

		if ~isempty(trim_line) && strncmp(opt.pre, trim_line, length(opt.pre)) 
			continue;
		end
		
	end
	
	%--
	% append input line to output file or line buffer
 	%--
	
	if isempty(fun)
		
		if buff_out
			lines{end + 1} = line;
		else
			line = strrep(strrep(line, '\', '\\'), '%', '%%'); fprintf(out.fid, [line, '\n']);
		end

		collapse = 0; continue;
	
	end
	
	%--
	% process line
	%--
			
	if ~has_state
		res = apply_fun(line, fun, args);
	else
		[res, state] = apply_fun(line, fun, args, state);
	end
	
	%--
	% append result
	%--
			
	if buff_out
		
		%--
		% append to line buffer
		%--
		
		if ischar(res)
			lines{end + 1} = res;
		else
			for k = 1:length(res)
				lines{end + 1} = res{k};
			end
		end
		
	else
		
		%--
		% append to output file
		%--
		
		% NOTE: line callbacks return character arrays, or string cell arrays
		
		if ischar(res)
			fprintf(out.fid, [printf_escape(res), '\n']);
		else
			for k = 1:length(res)
				fprintf(out.fid, [printf_escape(res{k}), '\n']);
			end
		end
		
		%--
		% display content when a printf warning was produced
		%--
		
		% NOTE: we display the offending result string and clear warning
		
		[ignore, id] = lastwarn;
		
		if strmatch('MATLAB:printf', id)
			xml_disp(res); lastwarn('');
		end
		
	end
	
	collapse = 0;
	
end

%--
% rename line buffer or close output file if needed
%--

if buff_out
	
	out = lines';
	
else
	
	if out.file
		fclose(out.fid);
	end

	if nargout
		out = dir(out.name);
	end
	
end

%--
% close input file if needed
%--

if ~buff_in
	
	if in.file
		fclose(in.fid); 
	end

end


