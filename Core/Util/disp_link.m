function str = disp_link(file, text)

% link_file - create a matlab link to a file
% ------------------------------------------
%
% str = link_file(file, text)
%
% Input:
% ------
%  file - file
%  text - link text
%
% Output:
% -------
%  str - link string

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


if nargin < 2 || isempty(text)
	text = file;
end

[ignore, ext] = file_ext(file);

switch ext
	
	case 'html' 
		
		type = 'matlab:web';
		
	otherwise
		
		type = 'matlab:edit';
		
end

str = ['<a href="', type, '(''', file, ''')">', text, '</a>'];

%--
% just display the link if we didn't ask for output
%--

if ~nargout
	disp(str);
end
