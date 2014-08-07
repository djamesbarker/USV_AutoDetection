function X = gray_create(f)

% gray_create - create gray image structure
% -----------------------------------------
%
% X = gray_create(f)
%
% Input:
% ------
%  f - image filename (def: file dialog)
%
% Output:
% -------
%  X - image structure

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
% $Revision: 1.1 $
% $Date: 2003-07-14 21:41:33-04 $
%--------------------------------

%--
% use load gray to get data
%--

if ((nargin < 1) | isempty(f))
	[data,file] = load_gray;
else
	[data,file] = load_gray(f);
end

%--
% pack image and file data into structure
%--

X.type = 'gray';
X.file = file.Filename;
X.data = data;
X.info = file;
