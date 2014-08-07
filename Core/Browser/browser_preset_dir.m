function p = browser_preset_dir(in,type)

% browser_preset_dir - get browser presets directory
% --------------------------------------------------
%
% p = browser_preset_dir(in,type)
%
% Input:
% ------
%  in - browser handle or type
%  type - preset type
%
% Output:
% -------
%  p - browser preset type root

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

% TODO: allow multiple roots to a preset type by pooling over browser types

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% set default figure and check for browser
%--

% TODO: develop function to test for browser figure

if ((nargin < 1) || isempty(in))
	in = gcf;
end

if (~is_browser(in))
	error('Input figure is not a browser.');
end

%--------------------------------
% GET DIRECTORY
%--------------------------------

if (all(ishandle(in)))

	if (numel(in) > 1)
		warning('Using first handle in list.'); in = in(1);
	end
	
	info = get_browser_info(in)
	
	in = browser_type_tag(info.type); 
	
	in(1) = upper(in(1)); type(1) = upper(type(1));
	
	% NOTE: reading of these paths requires some inversions
	
	p = [browsers_root, filesep, in, filesep, 'Presets', filesep, type];
	
end
