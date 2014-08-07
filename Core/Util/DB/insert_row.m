function sql = insert_row(in, name)

% insert_row - create table for struct array
% --------------------------------------------
%
% out = insert_row(in, name)
%
% Input:
% ------
%  in - struct array
%  name - table name
%
% Output:
% -------
%  out - struct output 

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

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% try to get name from input
%--

if nargin < 2
	
	name = inputname(1);
	
	if isempty(name)
		error('Unable to get table name from input name.');
	end
	
end
	
%---------------------------------
% CREATE QUERIES
%---------------------------------

%--
% flatten struct and use field names as column names
%--

in = flatten_struct(in); 

column = fieldnames(in);

%--
% build create table statement
%--

cols = {}; vars = {}; vals = {};

for k = 1:length(column)
	
	cols{end + 1} = column{k};
	
	vars{end + 1} = ['@', column{k}];
	
	vals{end + 1} = in.(column{k});
	
end

sql{1} = ['INSERT OR REPLACE INTO ', name, ' ('];

sql = {sql{:}, cols

sql{end}(end:end+1) = ' )';

%--
% evaluate in DB
%--


%--
% output sql as string as well as lines or display output
%--

if nargout
	str = sql_string(lines);
else
	sql_display(lines);
end

sqlite(file, sql, vals);


