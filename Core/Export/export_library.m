function export_library(lib,root,view)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

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
% HANDLE INPUT
%--------------------------------

%--
% set default view
%--

% NOTE: the name default is a convention

if ((nargin < 3) || isempty(view))
	view = 'default';
end

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% create library root directory
%--

% NOTE: this will create the libraries root directory if needed

lib_root = create_dir([root, filesep, 'Library', filesep, lib.name]);

if (isempty(lib_root))
	return;
end

%--
% create library page
%--

% data.id = lib.id;

data.lib = lib;

out = 'index.html';

process_template(view,'library',data,lib_root,out);

%--
% export library sounds
%--

sounds = get_library_sounds(lib)

for sound = sounds
	export_sound(lib,sound,lib_root,view);
end
