function pcode_refresh(mode)

% pcode_refresh - refresh pcodes files
% ------------------------------------

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
% $Date: 2005-08-25 10:08:48 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1670 $
%--------------------------------

% NOTE: dynamically do this, at the moment we have a short list

%----------------------------------------
% SETUP
%----------------------------------------

% NOTE: create list of files to possibly pcode at startup

list = { ...
	'control_group', ...
	'palette_toggle', ...
	'xbat_palette', ...
	'browser_palettes', ...
	'browser_controls', ...
	'browser_display' ...
};

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% set default mode
%--

if (nargin < 1)
	mode = 'clear';
end

%----------------------------------------
% REFRESH
%----------------------------------------

switch (mode)

	%--
	% clear and delete pcode
	%--

	case ('clear')

		for k = 1:length(list)

			file = which(list{k});

			if (file(end) == 'p')
				clear(list{k}); delete(file);
			end

		end

	%--
	% generate pcode
	%--

	case ('generate')

		for k = 1:length(list)
			pcode(list{k},'-inplace');
		end
		
	%--
	% unrecognized
	%--
	
	otherwise, error('Unrecognized mode option.');

end
