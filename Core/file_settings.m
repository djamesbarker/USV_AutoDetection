function flag = file_settings(mode,h,in)

% file_settings - handle settings data file
% -----------------------------------------
% 
%     settings = file_settings('read',f)
%
%         flag = file_settings('load',h,f)
%              = file_settings('write',h,settings)
%
% Input:
% ------
%  f - name of file to read
%  h - handle of relevant figure
%  settings - settings to write in file
%
% Output:
% -------
%  settings - settings read from file
%  flag - execution success flag

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
% get settings file
%--

try
			
	[fn,p] = uigetfile( ...
		{'*.mat','MAT-Files (*.mat)'; '*.*','All Files (*.*)'}, ...
		'Select XBAT Settings File: ' ...
	);  
	
	if (~fn)
		return;
	else
		tmp = load([p,fn]);
		field = fieldnames(tmp);
		if (length(field) > 1)
			disp(' ');
			warning('File does not contain a single settings variable.');
			return;
		end
		eval(['tmp = tmp.' field{1} ';']);
	end
	
catch
	
	disp(lasterr);
	return;
	
end

%--
% get userdata
%--

data = get(h,'userdata');

%--
% update settings and userdata
%--

data.browser.page = tmp.page;
data.browser.specgram = tmp.specgram;
data.browser.colormap = tmp.colormap;
data.browser.grid = tmp.grid;

set(h,'userdata',data);

%--
% update menus
%--



%--
% update display
%--

browser_display(h,'update',data);

% call grid color to update figure color

browser_sound_menu(h,rgb_to_color(tmp.grid.color));
