function struct_to_table(fid, in, label, level)

% struct_to_table - output struct as table to file
% ------------------------------------------------
%
% struct_to_table(fid, in, label)
%
% Input:
% ------
%  fid - file identifier
%  in - structure to process
%  label - class label for table container

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

% TODO: improved rendering of matrices and numeric types

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set level of recursion
%--

% NOTE: the level variable could have a variety of uses

if (nargin < 4)
	level = 1;
end 

%--
% set default class for container
%--

if (nargin < 3) || isempty(label)
	label = 'struct';
end

%--
% handle structure arrays recursively and wrap in list
%--

% TODO: wrap arrays in list

if (numel(in) > 1)
		
	for k = 1:numel(in)
		struct_to_table(fid, in(k), [], level);
	end
		
	return;

end

%--
% create various tags
%--

% TODO: make these persistent to help the recursion

% NOTE: all the tags have end of line characters

div = xml_tag('div', 'struct');

table = xml_tag('table');

tr = xml_tag('tr');

th = xml_tag('th');

% NOTE: odd and even class table cell tags to enable zebra tables

td(1) = xml_tag('td', 'odd'); td(2) = xml_tag('td', 'even');

%--
% open enclosing div and table
%--

fprintf(fid, div.open);

fprintf(fid, table.open);

%--
% loop over fields creating one row per field
%--

fields = fieldnames(in);

for k = 1:length(fields)

	%--
	% get field value
	%--

	value = in.(fields{k});

	%--
	% transform field if needed
	%--
	
	switch lower(fields{k})
		
		case {'created', 'modified'}
			
			if ~isempty(value)
				value = datestr(value);
			end
			
	end
	
	% NOTE: skip cell fields for the moment

	if iscell(value)
		continue;
	end

	%--
	% open field value row
	%--
	
	fprintf(fid, tr.open);
	
	%--
	% produce field cell
	%--

	% NOTE: use title caps to get rid of underscore characters
	
	str = tag_str(title_caps(fields{k}), 'span', 'field');
	
	str = tag_str(str, th);
	
	fprintf(fid, str);
	
	%--
	% open value cell
	%--
	
	% NOTE: cells can show zebra behavior, however this is not clean for nested tables
	
	if mod(k, 2)
		fprintf(fid, td(1).open);
	else
		fprintf(fid, td(2).open);
	end
	
	%--
	% produce value cell
	%--
	
	switch class(value)

		%--
		% character value
		%--
		
		case 'char'
			
			%--
			% consider special fields
			%--
			
			switch fields{k}
				
				%--
				% special fields
				%--
				
				case {'path', 'file'}
							
					% NOTE: replace xbat root string and escape string before wrapping
					
					value = html_escape(strrep(value, xbat_root, '$XBAT_ROOT'));
				
					value = tag_str(value, 'span', 'path');
			
				%--
				% generic fields
				%--
				
				otherwise

					value = html_escape(value);
					
			end
						
			fprintf(fid, value);

		%--
		% function handle value
		%--
		
		case 'function_handle'
			
			struct_to_table(fid, functions(value), 'function', level + 1);
			
		%--
		% struct value
		%--
		
		case 'struct'
			
			struct_to_table(fid, value, [], level + 1);
			
		%--
		% consider other values as matrices
		%--
		
		otherwise
			
			if ~isempty(value)
				fprintf(fid, html_matrix(value));
			else
				fprintf(fid, tag_str('EMPTY', 'span', 'empty'));
			end

	end

	%--
	% close value cell and field value row
	%--
	
	fprintf(fid, td.close);

	fprintf(fid, tr.close); 
	
end

%--
% close table and enclosing div
%--

fprintf(fid, table.close);

fprintf(fid, div.close);
