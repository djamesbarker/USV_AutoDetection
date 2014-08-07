function file = select_splash(ratio)

% select_splash - select splash image file considering screen size
% ----------------------------------------------------------------
%
% file = select_splash(ratio)
%
% Input:
% ------
%  ratio - desired screen to image width ratio (def: 2.5)
% 
% Output:
% -------
%  file - splash image file

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
% set default screen to image ratio
%--

if ~nargin
	ratio = 2.5;
end

%--
% get screen size
%--

screen = get_size_in(0, 'px', 1);

%--
% get candidate images and widths
%--

root = [fileparts(mfilename('fullpath')), filesep, 'Images'];

files = what_ext(root, 'png'); files = files.png;

widths = zeros(size(files));

for k = 1:length(files)
	info = imfinfo([root, filesep, files{k}]); widths(k) = info.Width;
end

%--
% select file closest to desired ratio
%--

[ignore, ix] = min(abs(widths - (screen.width / ratio)));

file = [root, filesep, files{ix}];
