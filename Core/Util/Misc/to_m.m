function str = to_m(in,var)

% to_m - try to convert a variable to code
% ----------------------------------------
%
% str = to_m(in,var)
%
% Input:
% ------
%  in - variable to convert to code
%  var - variable name
%
% Output:
% -------
%  str - code to generate in

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

% TODO: add a flag for when the conversion happens correctly

%--
% get or give the variable a name
%--

if ((nargin < 2) || isempty(var))
	
	var = inputname(1);
	
	% NOTE: the default variable name is out, as in the output of a function
	
	if (isempty(var))
		var = 'out';
	end

end


%--
% create the code
%--

if (isstruct(in))
	
	str = '';
	
	var = [var, '.'];

	in  = flatten_struct(in);
	
	fields = fieldnames(in);
	
	for k = 1:length(fields)
		
		value = in.(fields{k});
		
		switch (class(value))
				
			%------------------------------------------
			% CELL
			%------------------------------------------
			
			% NOTE: general cell arrays are hard to handle, string arrays are easy
			
			case ('cell')
				
				str = [str, var, strrep(fields{k},'__','.'), ' = ', cell_to_str(value), ';\n'];
				
			%------------------------------------------
			% CHAR
			%------------------------------------------
			
			case ('char')
								
				str = [str, var, strrep(fields{k},'__','.'), ' = ', char_to_str(value), ';\n'];
				
			%------------------------------------------
			% FUNCTION HANDLE
			%------------------------------------------
			
			case ('function_handle')
				
				str = [str, var, strrep(fields{k},'__','.'), ' = ', fun_to_str(value), ';\n'];
			
			%------------------------------------------
			% STRUCT
			%----------------------------------------
			
			% TODO: this seems to require some kind of recursive call
			
			case ('struct')
				
				str = [str, var, strrep(fields{k},'__','.'), ' = ''__STRUCT__'';\n'];

			%------------------------------------------
			% NUMERIC
			%------------------------------------------
			
			% NOTE: the 'mat2str' function used by 'mat_to_str' handles many types
			
			otherwise
				
				str = [str, var, strrep(fields{k},'__','.'), ' = ', mat_to_str(value), ';\n'];
				
		end
		
	end
	
	% NOTE: display string if no output requested
	
	if (~nargout)
		disp(' '); disp(sprintf(strrep(str,'\n','\n\n')));
	end
	
end


%------------------------------------------
% CELL_TO_STR
%------------------------------------------
			
function str = cell_to_str(in)

% NOTE: this only works properly for cell vectors

if (iscellstr(in))
	
	str = '{';

	for j = 1:length(in)
		str = [str, '''', in{j}, ''','];
	end

	if (~isempty(in))
		str(end) = '}';
	else
		str = [str, '}'];
	end
	
else
	
	str = '''__CELL__''';

end


%------------------------------------------
% CHAR_TO_STR
%------------------------------------------

function str = char_to_str(in)

% NOTE: escape any needed characters for use in printf

str = ['''', strrep(in,'\','\\'), ''''];


%------------------------------------------
% FUN_TO_STR
%------------------------------------------

function str = fun_to_str(in)

% NOTE: this function needs testing

fun = functions(in);

if (strcmp(fun.type,'simple'))
	str = ['@', fun.function];
else
	str = '''__FUNCTION_HANDLE__''';
end


%------------------------------------------
% MAT_TO_STR
%------------------------------------------

function str = mat_to_str(in)

% NOTE: this function needs testing

str = mat2str(in);

str = strrep(str,' ',', '); str = strrep(str,';','; ');

