function extension_message(ext, str, compact)

% extension_message - produce extension message 
% ---------------------------------------------
%
% extension_message(ext, str, compact)
%
% Input:
% ------
%  ext - extension
%  str - message
%  compact - indicator

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

%--
% set default compact message
%--

if nargin < 3
	compact = 1;
end

%--
% get caller
%--

stack = dbstack('-completenames'); caller = stack(2);

stack(1) = [];

%--
% build header and line
%--

type_str = upper(strrep(ext.subtype, '_', ' ')); 

name_str = upper(ext.name);

%--
% display message
%--

head = [' MESSAGE: From ', type_str, ' extension ''', name_str, '''. ', str];

if compact
	
	disp(' ');
	disp(head);
	disp([' ', caller_line(caller)]);
	disp(' ');
	
else

	line = str_line(head, '_');

	disp(' ');

	disp(line);
	disp(' ');
	disp(head);
	disp(line);
	
	disp(' ');
	disp(' STACK:');
	disp(' ')
	
	stack_disp(stack);
	
	% NOTE: the location of the message is the first element of the stack
	
% 	disp(' ');
% 	disp([' At ', caller_line(caller)]);
	
	disp(line);
	disp(' ');

end


%----------------------
% CALLER_LINE
%----------------------

function str = caller_line(caller)

str = [strrep(caller.file, extensions_root, '(extensions_root)'), ' at line ', int2str(caller.line)];

str = [ ...
	'<a href="matlab:opentoline(''', caller.file, ''',', int2str(caller.line), ')">', str, '</a>' ...
];
