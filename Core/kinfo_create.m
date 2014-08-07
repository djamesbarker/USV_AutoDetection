function info = kinfo_create(code)

% kinfo_create - create structure to support key reference
% --------------------------------------------------------
%
% info = kinfo_create(code)
%
% Input:
% ------
%  code - key code
%
% Output:
% -------
%  info - info container structure for key reference 

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% set empty code
%--

if (nargin < 1)
	code = [];
end

%--
% key name string from code
%--

if (~isempty(code))
	
	switch (code)
	
		%--
		% named keys
		%--
	
		case (8)
			key = 'Backspace';
			
		case (9)
			key = 'Tab';
			
		case (13)
			key = 'Enter';
			
		case (27)
			key = 'Escape';
			
		case (28)
			key = 'Left Arrow';
			
		case (29)
			key = 'Right Arrow';
			
		case (30)
			key = 'Up Arrow';
			
		case (31)
			key = 'Down Arrow';
			
		case (32)
			key = 'Space';
		
		case (127)
			key = 'Delete';
			
		%--
		% unnamed keys
		%--
		
		otherwise
			
			%--
			% uppercase alpha
			%--
			
			if ((code >= 65) & (code <= 90))
				
				key = {'Shift',upper(char(code))};
				
			%--
			% lowercase alpha
			%--
			
			elseif ((code >= 97) & (code <= 122))
				
				key = upper(char(code));
				
			%--
			% punctuation and numbers
			%--
			
			else
				
				key = char(code);
				
			end
			
	end

else
	
	key = [];
	
	code = [];
	
end

%--
% create structure
%--

info.key = key; 		% key name

info.code = code;		% key ascii code

info.category = [];		% command category

info.name = []; 		% command name

info.menu = []; 		% corresponing menu command (how should this be done ???)

info.description = []; 	% command description
