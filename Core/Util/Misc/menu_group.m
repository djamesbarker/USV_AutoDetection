function h = menu_group(g, fun, L, S, A, c)

% menu_group - append menu to figure or other menu
% ------------------------------------------------
%
% h = menu_group(g, fun, L, S, A, c)
%
% Input:
% ------
%  g - parent handle
%  fun - callback function
%  L - labels
%  S - separators (def: [])
%  A - accelerator keys (def: [])
%  c - controlled figure handle (def: gcf)
%
% Output:
% -------
%  h - handles to menu items

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

% TODO: update callbacks to use tags, the label can then be used to store state

% NOTE: get command from menu tag and further state from the label

% NOTE: calling update for menu commands will be worthwhile work

%--
% number of items
%--

n = length(L);

%--
% set accelerator keys
%--

if nargin < 5
	A = cell(1, n);
end

%--
% set separator flags
%--

if nargin < 4
	if n > 1
		S = bin2str(zeros(1, n));
	else
		S = {'off'};
	end
end

%--
% create callback strings
%--

if isempty(fun)	
	
	%--
	% informational menus, no callback
	%--
	
	for k = 1:n
		F{k} = [];
	end	
	
else

	if ischar(fun)

		if fun(end) == ';'
			fun(end) = [];
		end
		
		%--
		% toolbar formalism (focus controlled figure c, execute command, return to toolbar g)
		%--

		if nargin > 5

			for k = 1:n
				F{k} = [ ...
					'figure(', num2str(c), '); ' ...
					fun, '(gcf, ''', L{k}, '''); ', ...
					'figure(', num2str(g), ');' ...
				];
			end

		%--
		% standard menus (execute command on figure with menu)
		%--

		else 

			for k = 1:n
				F{k} = [fun, '(gcf, ''', L{k}, ''');'];
			end

		end		

	elseif isa(fun, 'function_handle')

		for k = 1:n
			F{k} = fun;
		end

	end
	
end

%--
% create menu items
%--

try
	type = get(g, 'type');
catch
	h = [], return;
end

switch type

	case 'figure'

		%--
		% create menu items (put label in label and tag, the latter helps with dynamic menus)
		%--
		
		% first item is the name of the menu, no callback
		
		h(1) = uimenu(g, ...
			'label', L{1}, ...
			'tag', L{1}, ...
			'callback', [] ...
		);
				
		for k = 2:n	
			
			h(k) = uimenu(h(1), ...
				'label', L{k}, ...
				'separator', S{k}, ...
				'callback', F{k} ... 
			);		
			
			if ~isempty(A{k})
				set(h(k), 'accelerator', A{k});
			end	

		end
	
	case {'uimenu', 'uicontextmenu'}
	
		%--
		% empty parent callback
		%--
		
		set(g, 'callback', []);

		%--
		% create menu items
		%--
		
		for k = 1:n
		
			h(k) = uimenu(g, ...
				'label', L{k}, ...
				'separator', S{k}, ...
				'callback', F{k} ...
			);
				
			if ~isempty(A{k})
				set(h(k), 'accelerator', A{k});
			end
			
		end
		
end
