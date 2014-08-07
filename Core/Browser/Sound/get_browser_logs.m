function [log, pos] = get_browser_logs(par, varargin)

% get_browser_logs - get browser logs
% -----------------------------------
%
% log = get_browser_logs(par, field, value, ... , data)
%
% Input:
% ------
%  par - parent browser
%  field - field name
%  value - field value
%  data - browser state
%
% Output:
% -------
%  log - browser logs

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

% TODO: add log index to output

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set default parent
%--

if ~nargin || isempty(par)
	par = get_active_browser;
end

% NOTE: return if there is no available parent

if isempty(par)
	log = []; pos = []; return;
end

%--
% check parent input
%--

if ~is_browser(par)
	error('Input handle is not browser handle');
end 

%--
% get parent state
%--

% NOTE: if argument list length is odd, last argument is state

if mod(length(varargin), 2)
	data = varargin{end}; varargin(end) = [];
else
	data = get_browser(par);
end

%--
% get all browser logs
%--

log = data.browser.log;

% NOTE: return if there is no selection

if isempty(log) || (length(varargin) < 1)
	return;
end

%---------------------------------
% SELECT LOGS
%---------------------------------

%--
% get selection field value pairs
%--

[field, value] = get_field_value(varargin);

ix = ones(1, length(log));

for k = 1:numel(field)
	
	switch field{k}
		
		%--
		% LOG TYPE SELECTION
		%--
		
		% TODO: the goal of this is to update the store of active detection logs
		
		case 'type'
			
			types = {'file', 'active'};
			
			if ~ismember(value{k},types)
				error(['Unrecognized log type ''', value{k}, '''.']);
			end
			
			switch value{k}
				
				case 'active'
					
				case 'file'
				
			end
			
		%--
		% LOG FIELD SELECTION
		%--
		
		% COMPUTED FIELDS
		
		case 'name'
			
			name = file_ext({log.file});
			
			ix = ix & strcmpi(name,value{k});
			
		% ACTUAL FIELDS
		
		otherwise
			
			if ~isfield(log, field{k})
				continue;
			end
		
			% NOTE: we only use string and numeric fields for selection
			
			switch class(log(1).(field{k}))
				
				case {'struct','cell'}
					
				case 'char', ix = ix & strcmpi({log.(field{k})}, value{k});
					
				otherwise, ix = ix & ([log.(field{k})] == value{k});
					
			end
			
	end
	
end

% TODO: consider empty index array possibility

pos = find(ix);

log = log(pos);
