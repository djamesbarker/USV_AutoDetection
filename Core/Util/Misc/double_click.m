function [value, t] = double_click(obj, T)

% double_click - check for double click
% -------------------------------------
%
% [value, t] = double_click(obj, T) 
%
% Input:
% ------
%  obj - target object 
%  T - click delay threshold
%
% Output:
% -------
%  value - double click indicator
%  t - double click delay

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
% $Revision: 5762 $
% $Date: 2006-07-18 12:49:26 -0400 (Tue, 18 Jul 2006) $
%--------------------------------

% TODO: make this function distinguish between code and GUI calls

%-----------------------
% SETUP
%-----------------------

%--
% create persistent stores
%--

persistent DOUBLE_CLICK_STATE DOUBLE_CLICK_TABLE LAST_CLICK_TYPE;

%--
% get possibly set default double click state
%--

if isempty(DOUBLE_CLICK_STATE)
	DOUBLE_CLICK_STATE = 'on';
end

state = DOUBLE_CLICK_STATE;

%--
% check for double click table, create if needed
%--

% NOTE: row contains: handle, clock vector, and first click indicator

if isempty(DOUBLE_CLICK_TABLE)
	DOUBLE_CLICK_TABLE = zeros(0, 8);
end

table = DOUBLE_CLICK_TABLE;

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% get double click state
%--

if nargin < 1
	value = state; t = []; return;
end

%--
% set double click state
%--

if isstr(obj)

	%--
	% check and set state
	%--
	
	state = lower(obj); states = {'on', 'off'};

	if ~ismember(state, states)
		error(['Unknown double click state ''', state, '''.']);
	end

	DOUBLE_CLICK_STATE = state;
	
	%--
	% set state, output state and return
	%--
	
	value = state; t = []; return;

end

%--
% return if double click state is off
%--

if strcmp(state, 'off')
	value = 0; t = []; return;
end

%--
% handle listbox separately
%--

if strcmp(get(obj, 'type'), 'uicontrol') && strcmp(get(obj, 'style'), 'listbox')

	value = strcmpi(get(ancestor(obj, 'figure'), 'selectiontype'), 'open'); t = nan; return;

end

%--
% get click type and ignore double right clicks
%--

% [alternate, type] = alternate_click(obj); 
% 
% if alternate
% 	
% 	if isempty(LAST_CLICK_TYPE)
% 		LAST_CLICK_TYPE = type; 
% 	end
% 	
% 	if strcmpi(type, 'open') && ~strcmpi(LAST_CLICK_TYPE, 'normal')
% 		value = 0; t = []; return;
% 	end
% 	
% 	LAST_CLICK_TYPE = type;
% 	
% end

%--
% set double click delay threshold
%--

if (nargin < 2) || isempty(T)
	T = 0.5;
end

%------------------------------------------
% CHECK FOR EVENT
%------------------------------------------

%--
% look for object handle in double click table
%--

ix = find(table(:,1) == obj, 1);

%--
% add object to double click table
%--

if isempty(ix)

	table(end + 1,:) = [obj, clock, 1];

	DOUBLE_CLICK_TABLE = table;
	
	value = 0; t = nan; return;

%--
% check delay condition on table object
%--

else

	switch table(ix, 8)

		%--
		% first click
		%--
		
		case (0)

			value = 0; t = nan; table(ix, 2:7) = clock; table(ix, 8) = 1; 

		%--
		% check second click
		%--
		
		case (1)

			t = etime(clock, table(ix, 2:7));

			%--
			% test for double click using delay
			%--
			
			% NOTE: on no double click, reset timer
			
			if (t < T)
				value = 1; table(ix, 8) = 0;
			else
				value = 0; table(ix, 2:7) = clock; table(ix, 8) = 1; 
			end

	end
	
	%--
	% update table
	%--

	DOUBLE_CLICK_TABLE = table;

end

%------------------------------------------
% GARGAGE COLLECTION
%------------------------------------------

if value && (size(table, 1) > 20)

	%--
	% check for no longer handles in table
	%--

	remove = find(~ishandle(table(:, 1)));
	
	if isempty(remove)
		return;
	end

	%--
	% update table
	%--
	
	table(ix, :) = [];
	
	DOUBLE_CLICK_TABLE = table;
	
end

