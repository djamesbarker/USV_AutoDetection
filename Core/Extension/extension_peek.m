function extension_peek(ext)

%--
% display extension info
%--

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

str = [' ', upper(ext.name)];

line = str_line(max(70,length(str) + 1));
		
disp(' ');
disp(line); 
disp(str); 
disp(line);

%--
% get extension function names and handles
%--

fun = flatten_struct(ext.fun);

names = fieldnames(fun);

handles = struct2cell(fun);

%--
% display extension function info
%--

disp(' ');

for k = 1:length(names)
	
	str = [' ', upper(names{k})]; 
	line = str_line(length(str) + 2);
		
	disp(line);
	disp(str); 
	disp(line);
	disp(' ');
	
	% NOTE: the xml conversion introduces a newline at the end
	
	if (~isempty(handles{k}))
		info = strrep(sprintf(to_xml(functions(handles{k}))),xbat_root,'$XBAT_ROOT');
		disp(info);	
	else
		disp('__UNDEFINED__');
		disp(' ');
	end
	
	disp(' ');

end
