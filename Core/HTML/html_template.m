function html_template(out, in, data)

% html_template - inject data into template
% -----------------------------------------
%
% html_template(out, in, data)
%
% Input:
% ------
%  out - output file or file identifier
%  in - template file
%  data - template data

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%----------------------------------
% HANDLE INPUT
%----------------------------------
	
%--
% consider template data input
%--

% NOTE: data may be empty or struct

if nargin < 3
	data = struct;
else
	if ~isstruct(data)
		error('Template data must be struct.');
	end
end

%--
% check input template file
%--

if ischar(in) && ~exist(in, 'file')
	error('Unable to find input template file.');
end

%----------------------------------
% PROCESS TEMPLATE
%----------------------------------

%--
% get output file identifier
%--

out = get_fid(out, 'wt');

%--
% output header if needed
%--

% NOTE: file output indicates independent file needing open and close

if out.file
	
	% NOTE: title and style may be part of data
	
	title = get_field(data, 'title', []);
	
	style = get_field(data, 'style', []);
	
	html_open(out.fid, title, style);
	
end

%--
% process template file
%--

% NOTE: consider no comments and skip empty input lines

opt = file_process; opt.skip = 1;

file_process(out.fid, in, {@template_process, data}, opt);

%--
% output close and close file if needed
%--

if out.file
	html_close(out.fid); fclose(out.fid);
end


%----------------------------------
% TEMPLATE_REPLACE
%----------------------------------

function lines = template_process(line, data)

% template_process - perform template processing
% ----------------------------------------------
%
% lines = template_process(line, data)
%
% Input:
% ------
%  line - line to process
%  data - template data
%
% Output:
% -------
%  lines - result of template line processing

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%--
% split line to find segments to process
%--

[seg, process] = line_split(line, '<%.*%>');

%--
% return quickly if no processing is needed
%--

if ~any(process)
	lines = line; return;
end

%--
% configure line read
%--

opt = file_readlines; opt.skip = 1;

%--
% loop over segments processing if needed
%--

lines = cell(0);

for k = 1:length(seg)
	
	%--
	% no processing segment
	%--
	
	if ~process(k)
		
		lines{end + 1} = seg{k};
	
	%--
	% process segment
	%--
	
	else
		
		%--
		% get and parse content of code segment
		%--
		
		% TODO: implement template commenting
		
		tok = str_split(seg{k}(3:end - 2));
		
		if (length(tok) > 2)
			error('Template expressions must contain at most two tokens.');
		end
		
		%--
		% consider commands
		%--
		
		switch tok{1}

			%--
			% include
			%--
			
			case 'include'
				
				if strcmp(tok{2}(1), '$')
					tok{2} = get_field(data, tok{2}(2:end), []);
				end
				
				% NOTE: we give the template another chance by using 'which'
								
				out = file_readlines(which(tok{2}), {@template_process, data}, opt);

			%--
			% replacement
			%--
			
			% NOTE: variable replacement not implemented yet
			
			otherwise
				
				if ~strcmp(tok{1}(1), '$')
					out = seg{k};
				else
					
					% NOTE: this only handles some scalar values
					
					value = get_field(data, tok{1}(2:end), []);
					
					out = to_str(value);
	
				end
				
		end
		
		%--
		% add processing output to resulting lines
		%--
		
		if ischar(out)
			lines{end + 1} = out;
		else
			for k = 1:length(out)
				lines{end + 1} = out{k};
			end
		end
		
	end
	
end

