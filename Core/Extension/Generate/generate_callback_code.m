function lines = generate_callback_code(control)

% generate_callback_code - generate callback skeleton from controls
% -----------------------------------------------------------------
%
% lines = generate_callback_code(control)
%
% Input:
% ------
%  control - control array
%
% Output:
% -------
%  lines - code lines for control callback skeleton

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

%--------------------------------------
% GENERATE CODE
%--------------------------------------

%--
% callbacks have a standard header
%--

% NOTE: this relies on input to callback being names 'obj'

lines = cell(0);

lines{end + 1} = 'callback = get_callback_context(obj, ''pack'');';
lines{end + 1} = ' ';
lines{end + 1} = 'result = []; control = callback.control; pal = callback.pal; par = callback.par;';
lines{end + 1} = ' ';
lines{end + 1} = 'switch callback.control.name';
lines{end + 1} = ' ';

%--
% add control switch cases
%--

for k = 1:length(control)

	% TODO: develop code for buttongroups
	
	switch control.style
		
		case {'separator', 'tabs'}
			continue;
			
		case 'buttongroup'
			continue;
			
		otherwise
			lines{end + 1} = ['    case ''', control.name, '''']; 
			lines{end + 1} = ' ';
			
	end
	
end

%--
% close switch and return
%--

lines{end + 1} = 'end';
lines{end + 1} = ' ';

% NOTE: output column cell array, readable in command line

lines = lines(:);
