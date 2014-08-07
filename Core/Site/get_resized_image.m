function [resized, file] = get_resized_image(site, name, width)

% GET_RESIZED_IMAGE get smaller resized image from site image
%
% [resized, file] = get_resized_image(site, name, width)

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
% set default width 
%--

if nargin < 3
	width = 256;
end

%--
% get parent image
%--

file = get_image(site, name);

if isempty(file)
	return;
end

%--
% get resize ratio to see if we need to resize
%--

info = imfinfo(file); M = width / info.Width;

% NOTE: the image is smaller than requested, there is no need to resize

if M >= 1
	resized = name; return;
end
		
%--
% build resized image name
%--

[root, name, ext] = fileparts(file);

resized = [name, '__', int2str(width), ext];

%--
% check for resized file in assets
%--

out = [root, filesep, resized];

if exist(out, 'file')
	file = out; return;
end

%--
% create resized image if needed
%--

imwrite(imresize(imread(file), M, 'bicubic'), out);

% NOTE: this will allow the system to find the new image

sites_cache_clear;

while ~exist(out, 'file')
	disp('Waiting on image resize ...'); pause(0.1);
end

file = out;

