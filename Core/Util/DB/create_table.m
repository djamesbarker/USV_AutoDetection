function [str, lines] = create_table(prototype, name, opt)

% create_table - create table for struct array
% --------------------------------------------
%
% [str, lines] = create_table(prototype, name, opt)
%
% Input:
% ------
%  prototype - struct
%  name - table name
%  opt - create options
%
% Output:
% -------
%  str - statement as string
%  lines - statement as lines

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
% set and possibly output create options
%--

if nargin < 3 
	
	%--
	% create options
	%--
	
	% NOTE: force new table and use hints to establish type affinity
	
	opt.force = 0; 
	
	opt.hint = 1; 
	
	%--
	% output create options
	%--
	
	if ~nargin
		str = opt; return;
	end

end

%--
% try to get name from input if needed
%--

if (nargin < 2) || isempty(name)
	
	name = inputname(1);
	
	if isempty(name)
		error('Unable to get table name from input name.');
	end
	
end
	
%---------------------------------
% CREATE STATEMENT
%---------------------------------

%--
% initialize statement and consider opt.force
%--

lines = {};

if opt.force
	lines{end + 1} = ['DROP TABLE IF EXISTS ', name, '; '];
end

%--
% build create table statement
%--

lines{end + 1} = ['CREATE TABLE IF NOT EXISTS ', name];


if isempty(prototype)
	
	% NOTE: we have no way of inferring columns, this is not typical
	
	lines{end} = [lines{end}, ';'];
	
else
	
	%--
	% use flat field names as column names
	%--

	prototype = flatten_struct(prototype);

	column = fieldnames(prototype);
	
	%--
	% continue statement
	%--
	
	lines{end} = [lines{end}, ' ('];

	for k = 1:length(column)

		if opt.hint
			
			%--
			% get type and constraints if using hinting
			%--
		
			hint = get_type_and_constraints(column{k}, prototype.(column{k}));

			lines{end + 1} = ['  ', column{k}, ' ', hint.type , ' ', hint.constraints, ','];
		
		else
			
			%--
			% only name columns if we are not using hints
			%--
			
			lines{end + 1} = ['  ', column{k}, ','];
			
		end

	end

	lines{end}(end) = [];

	lines{end + 1} = ');';
	
end

lines = strrep(lines(:), ' ,', ',');

%--
% output sql as string as well as lines or display output
%--

if nargout
	str = sql_string(lines);
else
	sql_display(lines);
end

	

