function h = test_ext_menu(n)

% test_ext_menu - test creation of extension menus
% ------------------------------------------------

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
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% set default test index
%--

if (nargin < 1)
	n = 4;
end

%--
% handle test index sequences
%--

if (length(n) > 1)
	
	for k = 1:length(n)
		test_ext_menu(n(k));
	end

	return;
	
end

%-------------------------
% SETUP
%-------------------------

%--
% get types
%--

types = get_extension_types;

%--
% create parent figure
%--

h = fig; 

pos = get(h,'position'); pos(3:4) = [600,150];

set(h, ...
	'name',['TEST ' int2str(n)], ...
	'position',pos ...
);

%-------------------------
% TESTS
%-------------------------

switch (n)

	%----------------------
	% TEST 1
	%----------------------

	case (1)

		% NOTE: create default parent menus

		for k = 1:length(types)
			browser_ext_menu(h,types{k});
		end

	%----------------------
	% TEST 2
	%----------------------

	case (2)

		% NOTE: create menus with given parent

		for k = 1:length(types)

			ext = get_extensions(types{k});

			% NOTE: skip types for which there are no extensions

			if (isempty(ext))
				continue;
			end

			g = uimenu(h,'label',['TYPE ', int2str(k)]);

			browser_ext_menu(g,types{k});

		end

	%----------------------
	% TEST 3
	%----------------------

	case (3)

		% NOTE: single menu with all extensions

		g = uimenu(h,'label','Extension');

		for k = 1:length(types)

			ext = get_extensions(types{k});

			% NOTE: skip types for which there are no extensions

			if (isempty(ext))
				continue;
			end

			sep = uimenu(g,'label',['(', title_caps(types{k}), ')']);

			if (k < 2)
				set(sep,'enable','off');
			else
				set(sep, ...
					'enable','off', ...
					'separator','on' ...
				);
			end

			browser_ext_menu(g,types{k});

		end

	%----------------------
	% TEST 4
	%----------------------

	case (4)

		%--
		% declare meta types and aliases for the types
		%--
		
		% NOTE: group common types, there are two ways of doing this: verb and noun

		meta.type = {'filter','detector','annotation','measure'};

		meta.name = meta.type;

		meta.name{2} = 'detect'; meta.name{3} = 'annotate';

		%--
		% loop over meta types
		%--
		
		for k = 1:length(meta.type)

			%--
			% get meta type child types
			%--

			child = cell(0);

			for j = 1:length(types)
				
				if (~isempty(findstr(meta.type{k},types{j})))
					child{end + 1} = types{j};
				end
				
			end

			%--
			% create meta type parent
			%--

			g = uimenu(h,'label',title_caps(meta.name{k}));

			%--
			% create child type menus
			%--

			% NOTE: this can be encapsulated in a function, it is used in TEST 3

			for j = 1:length(child)

				%--
				% get extensions of child type
				%--
				
				ext = get_extensions(child{j});

				if (isempty(ext))
					continue;
				end

				%--
				% create child type header menu if needed
				%--
				
				name = setdiff(str_split(child{j},'_'),meta.type{k});

				if (~isempty(name))

					name = name{1};

					sep = uimenu(g,'label',['(', title_caps(name), ')']);

					if (j < 2)
						set(sep,'enable','off');
					else
						set(sep, ...
							'enable','off', ...
							'separator','on' ...
							);
					end

				end

				%--
				% add extension menus for child type
				%--
				
				browser_ext_menu(g,child{j});

			end

		end

end
