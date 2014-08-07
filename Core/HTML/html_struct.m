function out = html_struct(out, in, title, style)

% html_struct - create struct html
% --------------------------------
%
% out = html_struct(out, in, title, style)
%
% Input:
% ------
%  out - output file or file identifier
%  in - struct to process
%  title - output title
%  style - output style
%
% Output:
% -------
%  out - output file, empty if operation failed

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
% empty output asks to use temp file
%--

if isempty(out)
	out = html_temp_file;
end

%--
% get file identifier
%--

out = get_fid(out, 'wt');

%--
% consider input type
%--

% NOTE: for file output we need title and style for header

if out.file
	
	%--
	% set style
	%--

	% NOTE: try to pass style with same name
	
	if (nargin < 4)
		style = [mfilename, '.css'];
	end

	%--
	% set title
	%--

	% NOTE: try to get title from structure input name

	if (nargin < 3)
		title = inputname(2);
	end
	
end

%----------------------------------
% CREATE CONTENT
%----------------------------------

%--
% output header for file output
%--

% NOTE: this function inlines the style file into the header

if out.file
	html_open(out.fid, title, style);
end

%--
% output content
%--

% TODO: add options for struct to table

% TODO: implement 'struct_to_list' and 'struct_to_div', consider generalization

struct_to_table(out.fid, in);

%--
% finish file output
%--

if out.file
	
	%--
	% close html and file
	%--
	
	html_close(out.fid); fclose(out.fid);
	
	%--
	% display file if no output was requested
	%--
	
	if ~nargout
		
		if exist(out.name, 'file')
            if ispc()
                winopen(out.name);
            end
            if ismac()
                system(['open ',out.name]);
            end
		else
			error('Unable to find output file for display.');
		end
		
	end
	
end
