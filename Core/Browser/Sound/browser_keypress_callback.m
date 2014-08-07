function browser_keypress_callback(obj, eventdata, par)

% browser_keypress_callback - callback helper for browser keypress function
% -------------------------------------------------------------------------
%
% browser_keypress_callback(obj, eventdata, par)

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
% get browser from callback handle
%--

if nargin < 3
	
	% NOTE: this should not be typicae, we should pass the parent
	
	if is_browser(obj)
		par = obj;
	else
		try
			par = get_palette_parent(obj);
		catch
			return;
		end
	end
	
end

%--
% get keypress information
%--

% NOTE: we get the keypress of the callback object

key = get_keypress(obj);

%--
% intercept keypress to implement some palette behaviors
%--

% NOTE: look at 'palette_kpfun' to get a better understanding of what we may want

if ~isequal(obj, par) && ismember(key.char, {'m', 'M', 'w'})
	
	switch key.char
		
		% NOTE: the 'palette_minmax' function should take the handle first
		
		case 'm', palette_minmax('min', obj);
			
		case 'M', palette_minmax('max', obj);
			
		case 'w', close(obj);
			
	end
	
	return;
	
end

%--
% call existing browser keypress function
%--

browser_kpfun(par, key);

%--
% focus update
%--

% NOTE: in many cases it should make sense to keep focus on caller
