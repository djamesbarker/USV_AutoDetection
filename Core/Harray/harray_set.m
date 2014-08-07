function value = harray_set(par, varargin)

% harray_set - set harray properties
% ----------------------------------
%
% value = harray_set(par, field, value, ... )
%
% Input:
% ------
%  par - parent
%  field - name
%  value - value
%
% Output:
% -------
%  value - value

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

% NOTE: this code experiments with field matching, this is a bad idea 

%------------------
% HANDLE INPUT
%------------------

%--
% get parent data
%--

data = harray_data(par); 

if isempty(data)
	error('Parent does not contain hierarchical axes array.');
end

%--
% return if there is nothing to set
%--

if length(varargin) < 1
	value = []; return;
end

%--
% check field value pairs
%--

% NOTE: we are not using these fields as allowed fields in 'get_field_value'

fields = {'toolbar', 'statusbar', 'colorbar', 'scale'};
	
% NOTE: the single input case makes bar toggle simple

if length(varargin) == 1
	field = varargin; value = {''};
else 
	[field, value] = get_field_value(varargin);
end

%------------------
% SET HARRAY
%------------------

for k = 1:length(field)
	
	%--
	% match field
	%--
	
	field{k} = match_field(field{k}, fields, 0);
	
	% TODO: decide how to indicate that this happened
	
	if isempty(field)
		continue;
	end
	
	%--
	% update data field
	%--
	
	switch field{k}
		
		case 'toolbar'
			[data, value{k}] = bar_update('tool', value{k}, data);
			
		case 'statusbar'
			[data, value{k}] = bar_update('status', value{k}, data);
			
		case 'colorbar'
			[data, value{k}] = bar_update('color', value{k}, data);
			
		case 'scale'

			if isempty(value{k})
				continue;
			end 
			
			data.base = layout_scale(data.base, value{k});

			data.layout = layout_scale(data.layout, value{k});
			
	end
	
end

%--
% update data
%--

% NOTE: consider incremental updates as an option

harray_data(par, data);


%------------------
% BAR_UPDATE
%------------------

function [data, state] = bar_update(name, state, data)

%--
% update data
%--

switch state
	
	case 'on', data.base.(name).on = 1;
		
	case 'off', data.base.(name).on = 0;
	
	% NOTE: this is for 'toggle' we are lenient on the description
	
	otherwise
		
		data.base.(name).on = double(~data.base.(name).on);
		
		if data.base.(name).on
			state = 'on';
		else
			state = 'off';
		end

end


%------------------
% MATCH_FIELD
%------------------

% TODO: this may be useful on it's own ... or perhaps within 'get_field_value'

function [field, ix] = match_field(field, fields, exact)

% match_field - match putative possibly partial field string to field
% -------------------------------------------------------------------
%
% [field, ix] = match_field(field, fields, exact)
%
% Input:
% ------
%  field - putative field
%  fields - known fields
%  exact - exact match indicator
%
% Output:
% -------
%  field - field matched
%  ix - match indices

%--
% handle input
%--

if nargin < 3
	exact = 0;
end

if ~iscellstr(fields)
	error('Fields input must be string cell array.');
end

if ~ischar(field)
	error('Field input must be string.');
end

%--
% match field
%--

if exact
	ix = strmatch(field, fields, 'exact');
else
	ix = strmatch(field, fields);
end

% NOTE: when we get none or multiple matche field output is empty

if numel(ix) ~= 1
	field = '';
else
	field = fields{ix};
end


