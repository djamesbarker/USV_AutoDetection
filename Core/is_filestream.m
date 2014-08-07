function flag = is_filestream(p)

% is_filestream - check if contents of folder are file stream
% -----------------------------------------------------------
%
% flag = is_filestream(p)
%
% Input:
% ------
%  p - location of directory
%
% Output:
% -------
%  flag - result of test

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
% $Revision: 950 $
% $Date: 2005-04-20 02:22:39 -0400 (Wed, 20 Apr 2005) $
%--------------------------------

%----------------------------------------------------
% HANDLE INPUT
%----------------------------------------------------

%--
% set path to current directory
%--

if ((nargin < 1) | isempty(p))
	p = pwd;
end

%--
% get file contents of directory
%--

% NOTE: we remove self and parent references

d = dir(p); d = d(3:end);

for k = length(d):-1:1
	if (d(k).isdir)
		d(k) = [];
	end
end

%--
% get filenames and extensions
%--

[name,ext] = file_ext(struct_field(d,'name'));

%--
% check for unique sound type extension
%--

% NOTE: this is not a real requirement for the sound reading functions, however
% it is good policy that this be the case, and further this is the typical
% case

ext = unique(ext);

if (length(ext) > 1)
	flag = 0;
	return;
end

%--
% check that the extensions are recognized sound extensions
%--

SOUND_EXT = {'aif','AIF','wav','WAV'}; % these will be extended

if (isempty(strcmp(SOUND_EXT,ext{1})))
	flag = 0;
	return;
end

%--
% check for a sequential naming scheme
%--

% clearly this is not very well defined, we are conservative in our
% definition, even though sound_create will perform further tests to check
% consistency of the files as a sound group

% try to infer consistent characters in scheme

n = length(name);

ix = round(n * rand(1,8));

% while
% 	strncmp(name
% end
