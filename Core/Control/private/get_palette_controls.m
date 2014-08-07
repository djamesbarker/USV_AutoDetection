function controls = get_palette_controls(pal)

% get_palette_controls - get palette controls array
% -------------------------------------------------
%
% controls = get_palette_controls(pal)
%
% Input:
% ------
%  pal - palette handle (def: gcf) 
%
% Output:
% -------
%  controls - control array

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
% $Revision: 3408 $
% $Date: 2006-02-06 15:40:18 -0500 (Mon, 06 Feb 2006) $
%--------------------------------

%------------------------------
% GET CONTROLS
%------------------------------

data = get(pal,'userdata'); 

controls = [];

if ~isfield(data, 'control')
	return;
end

controls = data.control;
