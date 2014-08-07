function [status, result] = sqlite(file, mode, sql, parameters)

% sqlite - sqlite access
% ----------------------
%
% [status, result] = sqlite(file, mode, sql, parameters)
%
% Input:
% ------
%  file - database file
%  mode - access mode
%  sql - sql
%  parameters - parameters
%
% Output:
% -------
%  status - status
%  result - result

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

%---------------------
% HANDLE INPUT
%---------------------

%--
% check required statements
%--

if (nargin < 3) || isempty(mode) || isempty(sql)
	error('Database file, access mode, and SQL input are required.');
end

%--
% check mode and get MEX code
%--

modes = {'exec', 'get_table', 'prepared'};

if ~ismember(mode, modes)
	error('Unrecognized database access mode.');
end

switch mode
	
	case 'exec', mode = 1;
		
	case 'get_table', mode = 2;
		
	case 'prepared', mode = 3;
		
end

%--
% ensure SQL string
%--

if ~ischar(sql) && ~iscellstr(sql)
	error('SQL input must be string or string cell array.');
end

sql = sql_string(sql);

%--
% check parameters
%--

% NOTE: it is easier to check here rather than in the MEX

if nargin > 3
	
	if (ndims(parameters) ~= 2) || ~iscell(parameters)
		error('Parameters must be a cell matrix.');
	end
	
	[count, sets] = size(parameters);
	
	if count ~= count_parameters(sql)
		error('SQL parameter count does not match available parameters.');
	end
	
	% NOTE: does this ever happen given the dimension test?
	
	if ~sets
		error('There are no available parameter sets.');
	end 
	
end

%---------------------
% ACCESS DATABASE
%---------------------

%--
% execute statement
%--

if nargin < 4
	status = sqlite_mex(file, mode, sql);
else
	status = sqlite_mex(file, mode, sql, parameters);
end

result = [];


%---------------------
% COUNT_PARAMETERS
%---------------------

function count = count_parameters(sql)

% NOTE: we are only handling positional parameters

count = length(find(sql == '?'));
