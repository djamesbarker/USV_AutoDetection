function str = to_xml(in, format, root, level)

% to_xml - create xml representation of variable
% ----------------------------------------------
%
% str = to_xml(in, format, root)
%
% Input:
% ------
%  in - input variable
%  format - conversion format for floating point types
%  root - root element
%
% Output:
% -------
%  str - xml representation of variable

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
% $Revision: 3443 $
% $Date: 2006-02-07 18:46:00 -0500 (Tue, 07 Feb 2006) $
%--------------------------------

% TODO: finish implementing display of empty fields

% TODO: add 'numel' attribute to array elements

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% set default level
%--

if ((nargin < 4) || isempty(level))
	level = 0;
end

%--
% set default root
%--

if (((nargin < 3) || isempty(root)) && (level == 0))
	root = inputname(1);
end 

%--
% set default format
%--

if (nargin < 2)
	format = '';
end 

%----------------------------------------
% CREATE XML REPRESENTATION
%----------------------------------------

%--
% initialize output string
%--

% TODO: check that this is the correct way to describe this document

% TODO: make this header optional

if (level == 0)
	str = '<?xml version="1.0" encoding="utf-8"?>\n';
else
	str = '';
end

%--
% convert variable based on type
%--

%--
% string
%--

if ischar(in)
	
	str = [str, char_to_xml(in, format, root, level)];
		
%--
% sparse matrix
%--

elseif issparse(in)
	
	if (level > 0)
		root = '';
	end
	
	str = [str, sparse_to_xml(in, format, root, level)];
	
%--
% numeric matrix
%--

elseif isnumeric(in) || islogical(in)
	
	if (level > 0)
		root = '';
	end
	
	% NOTE: we convert the logical into integer at the moment
	
	if islogical(in)
		in = uint8(in);
	end
	
	% NOTE: this code uses the format directly
	
	str = [str, mat_to_xml(in, format, root, level)];
	
%--
% cell array
%--

elseif iscell(in)
	
	% NOTE: container variables may have numeric leaves that need a format

	str = [str, cell_to_xml(in, format, root, level)];
	
%--
% struct
%--

elseif isstruct(in)
	
	% NOTE: container variables may have numeric leaves that need a format
	
	str = [str, struct_to_xml(in, format, root, level)];
	
%--
% function handles
%--

elseif strcmp(class(in), 'function_handle')
	
	% NOTE: arrays of function handles will not be supported in future versions of matlab

	temp = functions(in); 
	
	str = [str, struct_to_xml(temp, format, 'function_handle', level)];
	
%--
% object
%--

elseif isobject(in)

	%--
	% convert object to equivalent struct
	%--
	
	% TODO: get and display class information somehow
	
	temp = struct(in);
	
	str = [str, struct_to_xml(temp, format, 'object', level)];
	
%--
% unimplemented classes
%--

else
	
	% NOTE: return empty for unimplemented classes
	
	% TODO: display some message here

	str = '';
	
end


%-----------------------------------------------------------------
% CELL_TO_XML
%-----------------------------------------------------------------

function str = cell_to_xml(in, format, root, level)

% cell_to_xml - create xml representation of cell array
% -----------------------------------------------------
%
% str = cell_to_xml(in, format, root, level)
%
% Input:
% ------
%  in - cell array
%  format - conversion format for floating point types
%  root - root element
%  level - level of indentation
%
% Output:
% -------
%  str - xml string representation of cell matrix

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3443 $
% $Date: 2006-02-07 18:46:00 -0500 (Tue, 07 Feb 2006) $
%--------------------------------

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% return quickly on empty 
%--

if isempty(in)
	str = ''; return;
end

%--
% get dimensions information
%--

[d, nd, dims] = get_dims(in);

%----------------------------------------
% CREATE XML REPRESENTATION
%----------------------------------------

%--
% create depending on dimension of matrix
%--

switch (nd)
	
	%----------------------------------------
	% SCALAR CELL
	%----------------------------------------
	
	case (0)
		
		%--
		% create cell contents string
		%--
		
		strj = to_xml(in{1}, format, '', level + 1);
		
		%--
		% create xml string
		%--
			
		if isempty(findstr(strj(1:end - 2), '\n')) && (length(strj) < 102)

			% NOTE: strip tabs and new line from string (this could lead to problems)

			strj = strj(max(findstr(strj, '\t')) + 2:end - 2);

			str = [ ...
				tab_str(level), '<cell>', strj, '</cell>\n' ...
			];

		%--
		% multiple line contents
		%--

		else

			str = [ ...
				tab_str(level) '<cell>\n' ...
				strj ...
				tab_str(level) '</cell>\n' ...
			];

		end
		
	%----------------------------------------
	% CELL ARRAY
	%----------------------------------------
	
	otherwise

		%--
		% open xml string (produce depending on availability of root)
		%--
				
		str = [tab_str(level) '<cell dims="', dims, '">\n'];
		
		%--
		% add cell entries to xml string
		%--
		
		for k = 1:prod(d)
			
			%--
			% create cell contents string
			%--
			
			strj = to_xml(in{k}, format, '', level + 2);
		
			%--
			% single line contents
			%--
			
			if isempty(findstr(strj(1:end - 2), '\n')) && (length(strj) < 102)
					
				% NOTE: strip tabs and new line from string (this could lead to problems)
				
				strj = strj(max(findstr(strj, '\t')) + 2:end - 2);
				
				str = [str, ...
					tab_str(level + 1) '<element>' strj '</element>\n' ...
				];
			
			%--
			% multiple line contents
			%--
			
			else
				
				str = [str, ...
					tab_str(level + 1), '<element>\n', ...
					strj, ...
					tab_str(level + 1), '<element>\n' ...
				];
			
			end
		
		end
		
		%--
		% close xml string
		%--
		
		str = [str, tab_str(level), '</cell>\n'];
		
end


%-----------------------------------------------------------------
% CHAR_TO_XML
%-----------------------------------------------------------------

function str = char_to_xml(in, format, root, level)

% char_to_xml - create xml representation of char
% -----------------------------------------------
%
% str = char_to_xml(in, format, root, level)
%
% Input:
% ------
%  in - char array
%  format - not currently used
%  root - root element
%  level - level of indentation
%
% Output:
% -------
%  str - xml representation of char

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3443 $
% $Date: 2006-02-07 18:46:00 -0500 (Tue, 07 Feb 2006) $
%--------------------------------

%----------------------------------------
% CHECK INPUT
%----------------------------------------

%--
% check dimension
%--

if (ndims(in) > 2)
	error('Higher dimensional character arrays are not supported.');
end

%----------------------------------------
% CREATE STRING REPRESENTATION
%----------------------------------------

%--
% create single string from char matrix
%--

% NOTE: handle single multiple row strings

if (size(in, 1) > 1)
		
	in = strcat(tab_str(level + 1), in, '\n')'; 
	
	in = in(:)';
	
end

%--
% escape backslash characters and comment prefix
%--

in = strrep(in, '\', '\\');

in = strrep(in, '%', '%%'); 

%--
% create xml representation
%--

if (size(in, 1) < 2)
	
	%--
	% single line string
	%--

	str = [ ...
		tab_str(level) '<char>' in '</char>\n' ...
	];

else
	
	%--
	% multiple line string
	%--
	
	str = [ ...
		tab_str(level) '<char>\n' ...
		in ...
		tab_str(level) '</char>\n' ...
	];
	
end


%-----------------------------------------------------------------
% SPARSE_TO_XML
%-----------------------------------------------------------------

function str = sparse_to_xml(in, format, root, level)

% sparse_to_xml - create xml representation of sparse arrays
% ----------------------------------------------------------
%
% str = mat_to_xml(in, format, root, level)
%
% Input:
% ------
%  in - sparse array
%  format - conversion format for floating point types
%  root - root element
%  level - level of indentation
%
% Output:
% -------
%  str - xml representation of numeric array

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3443 $
% $Date: 2006-02-07 18:46:00 -0500 (Tue, 07 Feb 2006) $
%--------------------------------

%----------------------------------------
% CHECK INPUT
%----------------------------------------

%--
% return quickly on empty 
%--

if isempty(in)
	str = ''; return;
end

%----------------------------------------
% INITIALIZATION
%----------------------------------------

%--
% get dimensions information and string
%--

[d, nd, dims] = get_dims(in);

%--
% get class tag and entry conversion function
%--

[tag, fun] = get_numeric_class(in);

%----------------------------------------
% CREATE XML REPRESENTATION
%----------------------------------------

str = '';

%--
% open root wrapper
%--

if ~isempty(root)
	str = [str, tab_str(level), '<', root, '>\n']; level = level + 1;
end

%--
% add contents
%--

switch (nd)
		
	%----------------------------------------
	% sparse scalar
	%----------------------------------------
	
	% NOTE: this case should not happen typically
	
	case (0)
				
		str = [str, tab_str(level), '<', tag, '>', fun(in, format), '</', tag, '>\n'];
		
	%----------------------------------------
	% sparse matrix
	%----------------------------------------
	
	% NOTE: higher dimensional sparse arrays are currently not supported
	
	otherwise
		
		%--
		% open xml representation
		%--
				
		str = [str, tab_str(level), '<sparse class="', tag, '" dims="', dims, '">\n'];
		
		%--
		% add entries to xml representation
		%--
		
		[i, j, x] = find(in);
				
		for k = 1:length(i)
			str = [str, tab_str(level + 1), int2str(i(k)), ', ', int2str(j(k)), ', ', fun(x(k),format), ';\n'];
		end
				
		%--
		% close xml representation
		%--
		
		str = [str, tab_str(level) '</sparse>\n'];
		
end

%--
% close root wrapper
%--

if ~isempty(root) 
	str = [str, tab_str(level - 1), '</', root, '>\n'];
end


%-----------------------------------------------------------------
% MAT_TO_XML
%-----------------------------------------------------------------

function str = mat_to_xml(in, format, root, level)

% mat_to_xml - create xml representation of numeric arrays
% --------------------------------------------------------
%
% str = mat_to_xml(in, format, root, level)
%
% Input:
% ------
%  in - numeric array
%  format - conversion format for floating point types
%  root - root element
%  level - level of indentation
%
% Output:
% -------
%  str - xml representation of numeric array

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3443 $
% $Date: 2006-02-07 18:46:00 -0500 (Tue, 07 Feb 2006) $
%--------------------------------

%----------------------------------------
% INITIALIZATION
%----------------------------------------

%--
% get dimensions information and string
%--

[d, nd, dims] = get_dims(in);

%--
% get class tag and entry conversion function
%--

[tag, fun] = get_numeric_class(in);

%----------------------------------------
% CREATE XML REPRESENTATION
%----------------------------------------

str = '';

%--
% open root wrapper
%--

if ~isempty(root)
	str = [str, tab_str(level), '<', root, '>\n']; level = level + 1;
end

%--
% add contents
%--

switch (nd)
		
	%--
	% numeric scalar
	%--
	
	case (0)
				
		str = [str, tab_str(level), '<', tag, '>', fun(in, format), '</', tag, '>\n'];
		
	%--
	% numeric array
	%--
	
	otherwise
		
		%--
		% open xml representation
		%--
				
		str = [str, tab_str(level), '<matrix class="', tag, '" dims="', dims, '">\n'];
		
		%--
		% add entries and close xml representation
		%--
		
		if isempty(in)
		
			str(end - 1:end) = []; str = [str, '</matrix>\n'];
			
		else
			
			str = [str, tab_str(level + 1)];

			for k = 1:(prod(d) - 1)

				str = [str, fun(in(k), format), ', '];

				if ((d(1) > 1) && (mod(k, d(1)) == 0))
					str = [str, '\n', tab_str(level + 1)];
				end

			end
		
			str = [str, fun(in(end), format), '\n'];
		
			str = [str, tab_str(level) '</matrix>\n'];
			
		end

end

%--
% close root wrapper
%--

if ~isempty(root)
	str = [str, tab_str(level - 1), '</', root, '>\n'];
end


%-----------------------------------------------------------------
% GET_NUMERIC_CLASS
%-----------------------------------------------------------------

function [tag, fun] = get_numeric_class(in)

%--
% get tag from class
%--

tag = lower(class(in));

%--
% set conversion function
%--

switch tag

	% floating point conversions

	case {'single', 'double'}
	
		fun = @local_num2str;
		
	% integer conversions 

	otherwise
		
		fun = @local_int2str;

end


%-----------------------------------------------------------------
% STRUCT_TO_XML
%-----------------------------------------------------------------

function str = struct_to_xml(in, format, root, level)

% struct_to_xml - create xml representation of struct
% ---------------------------------------------------
%
% str = struct_to_xml(in, format, root, level)
%
% Input:
% ------
%  in - struct array
%  format - conversion format for floating point types
%  root - root element
%  level - level of indentation
%
% Output:
% -------
%  str - xml string representation of struct matrix

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3443 $
% $Date: 2006-02-07 18:46:00 -0500 (Tue, 07 Feb 2006) $
%--------------------------------

%----------------------------------------
% CHECK INPUT
%----------------------------------------

%--
% return quickly on empty 
%--

if isempty(in)
	str = ''; return;
end

%--
% get dimensions information
%--

[d, nd, dims] = get_dims(in);

%--
% get struct fields
%--

field = fieldnames(in);

n = length(field);

%--
% set default struct root
%--

if isempty(root)
	root = 'struct';
end

%----------------------------------------
% CREATE STRING 
%----------------------------------------

%--
% create depending on dimension of array
%--

switch (nd)
	
	%----------------------------------------
	% SCALAR STRUCT
	%----------------------------------------
		
	case (0)
		
		str = '';
		
		%--
		% create fields string
		%--
		
		for j = 1:n
			
			%--
			% set field tag
			%--
						
			tag = field{j};
			
			%--
			% create field string
			%--
						
			% NOTE: look out for double fields based on root passed here
							
			if isstruct(in.(field{j}))
				
				strj = to_xml(in.(field{j}), format, tag, level + 1);
				
				str = [str, strj];
				
				continue;
				
			else
				
				strj = to_xml(in.(field{j}), format, tag, level + 2);
				
			end
			
			%--
			% update output string
			%--
			
			if ~isempty(strj)

				%--
				% single line field strings
				%--
													
				if isempty(findstr(strj(1:end - 2), '\n')) && (length(strj) < 102)
					
					% NOTE: strip tabs and new line from string (this could lead to problems)
					
					strj = strj(max(findstr(strj, '\t')) + 2:end - 2);
					
					str = [str, ...
						tab_str(level + 1), '<', tag, '>', strj, '</', tag, '>\n' ...
					];
				
				%--
				% multiple line field strings
				%--
				
				else
					
					str = [str, ...
						tab_str(level + 1), '<', tag, '>\n', ...
						strj, ...
						tab_str(level + 1), '</', tag, '>\n' ...
					];
				
				end
			
			end
		
		end
		
		%--
		% check for empty field string
		%--
		
		if isempty(str)
			return;		
		end
		
		%--
		% wrap structure
		%--
		
		str = [ ...
			tab_str(level) '<' root '>\n', ...
			str, ...
			tab_str(level), '</' root '>\n' ...
		];
		
	%----------------------------------------
	% STRUCT ARRAY
	%----------------------------------------	
	
	otherwise

		%--
		% open structure array
		%--
		
		% TODO: add comments explaining the ordering of the entries
		
		str = '';
		str = [str, tab_str(level), '<', root, '>\n'];
		str = [str, tab_str(level + 1), '<matrix class="struct" dims="' dims '">\n'];
		
		%--
		% add elements of the structure array
		%--
				
		% TODO: consider adding index information to the elements
		
		for k = 1:prod(d)
			str = [str, struct_to_xml(in(k), format, 'element', level + 2)];
		end
		
		%--
		% close structure array
		%--
		
		str = [str, tab_str(level + 1), '</matrix>\n'];
		str = [str, tab_str(level), '<', root, '>\n'];
		
end


%-----------------------------------------------------------------
% LOCAL_NUM2STR
%-----------------------------------------------------------------

% NOTE: this is a number to string conversion that accepts a sprintf format

function str = local_num2str(in, format)

if isempty(format)	
	str = num2str(in, 32);
else
	str = sprintf(format, in);
end


%-----------------------------------------------------------------
% LOCAL_INT2STR
%-----------------------------------------------------------------

% NOTE: the goal of this function is to ignore the second input

function str = local_int2str(in, format)

str = int2str(in);

