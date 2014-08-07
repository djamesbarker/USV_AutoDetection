function XX = rgb_create(f)

% rgb_create - create rgb image structure
% ---------------------------------------
%
% XX = rgb_create(f)
%
% Input:
% ------
%  f - image filename (def: file dialog)
%
% Output:
% -------
%  XX - image structure

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
% $Revision: 1.0 $
% $Date: 2003-09-16 01:31:28-04 $
%--------------------------------

%--
% use load rgb to get image and file data
%--

if ((nargin < 1) | isempty(f))
	[data,file] = load_rgb;
else
	[data,file] = load_rgb(f);
end

%--
% pack image and file data into structure
%--

XX.type = 'rgb';
XX.file = file.Filename;
XX.data = data;
XX.info = file;
