function S = log_info_str(log, fields)

% log_info_str - create string cell array with log info
% -----------------------------------------------------
%
% S = log_info_str(log, fields)
%
% Input:
% ------
%  log - log to get info from
%  fields - log fields to display
%
% Output:
% -------
%  S - cell array of info strings

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
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------

% TODO: cache log information to be more responsive

% TODO: develop 'info_str' framework

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

if numel(log) > 1 
	fields = 'multiple';
elseif nargin < 2
	fields = [];
end

%--
% set fields if needed
%--

if (nargin < 2) && isempty(fields)
	
	fields = { ...
		'id', ...
		'length', ...
		'author', ...
		'created', ...
		'modified' ...
	};

end

if strcmp(fields, 'multiple')
	
	S = '(Multiple Logs Selected)';
	
% 	if isempty(log)
% 		events = 0;
% 	else
% 		events = numel([log.event]);
% 	end
% 	
% 	S = [integer_unit_string(numel(log), 'log'), ', ', integer_unit_string(events, 'event')]; return;
	
end

%-----------------------------------------------------
% CREATE INFO STRING CELL
%-----------------------------------------------------

%----------------------------
% NAME
%----------------------------

% NOTE: the name is directly computed from the file

S = {['Log:  ', log_name(log)]};

%----------------------------
% OTHER FIELDS
%----------------------------

for k = 1:length(fields)
	
	%--
	% skip non field fields and empty fields
	%--
	
	if ~isfield(log, fields{k})
		continue;
	end
	
	%--
	% create label section of string
	%--
	
	% TODO: implement some kind of 'alias' mechanism to change the field names
	
	str = [title_caps(fields{k},'_'), ':  '];
	
	%--
	% handle empty fields
	%--
	
	if isempty(log.(fields{k}))
		
		str = [str, '(Not Available)']; 
		
		S{end + 1} = str; continue;
		
	end
		
	%--
	% handle non empty fields
	%--
	
	switch fields{k}

		%--
		% ID
		%--

		case 'id'

% 			S{end + 1} = [str, int2str(log.id)];

		%--
		% Length
		%--

		% NOTE: log length has events label

		case 'length'

			S{end + 1} = [str, int2str(log.length)]; % label length as events

		%--
		% Created and Modified Dates
		%--

		case {'created', 'modified'}

			% display datetimes only if non-empty

			value = log.(fields{k});

			if ~isempty(value)
				S{end + 1} = [str, datestr(value)];
			end

		%--
		% other fields
		%--

		% NOTE: display is based on value type evaluation

		otherwise

			%--
			% get field value and produce display
			%--

			value = log.(fields{k});

			% NOTE: only strings and scalar numerics arrays are displayed

			if isstr(value)

				S{end + 1} = [str, value];

			elseif isnumeric(value) && (length(value) == 1)

				if (round(value) == value)
					S{end + 1} = [str, int2str(value)]; 
				else
					S{end + 1} = [str, num2str(value)]; 
				end

			end

	end 
			
end
