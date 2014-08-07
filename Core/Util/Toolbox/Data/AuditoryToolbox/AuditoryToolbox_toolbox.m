function toolbox = AuditoryToolbox_toolbox

%------------------------
% DATA
%------------------------

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

toolbox.name = 'AuditoryToolbox';

% TODO: we should check these are available periodically, use 'curl' to get info

toolbox.url = 'http://cobweb.ecn.purdue.edu/~malcolm/interval/1998-010/AuditoryToolbox.zip';

toolbox.install = @install;


%------------------------
% INSTALL
%------------------------

function install

%--
% get root and go to it
%--

p1 = pwd;

root = real_toolbox_root('AuditoryToolbox'); 

cd(root);

%--
% remove old mex files for various platforms
%--

% TODO: we should check we can build before we discard pre-compiled MEX

ext = all_mexext;

for k = 1:length(ext)
	delete(fullfile(root, ['*.', ext{k}]));
end

% NOTE: this is an extraneous directory in the 'zip'

if exist(fullfile(root, '.rsrc'), 'dir') == 7
    rmdir(fullfile(root, '.rsrc'));
end

%--
% build mex files for this platform
%--

file = dir(fullfile(root, '*.c')); 

for k = 1:length(file)
	
	% NOTE: we build this below
	
	if strcmp(file(k).name, 'dtw.c')
		continue;
	end
	
	try
		build_mex(file(k).name);
	catch
		nice_catch;
	end
	
end

% NOTE: 'agc.c' is compiled a second time to get 'inverseagc'

build_mex( ...
    'agc.c', ...
    '-DINVERSE', ...
    '-output', 'inverseagc' ...
);

% NOTE: 'dtw.c' needs a pre-processor variable defined for compilation

build_mex( ...
    'dtw.c', ...
    '-DMATLAB' ...
);

%--
% replace patched files
%--

% TODO: factor this operation

% TODO: report this simple bug to the owner

patched = { ...
	'SeneffEarSetup.m' ...
};

files = fullfile(fileparts(mfilename('fullpath')), 'Files');

for k = 1:length(patched)
	copyfile(fullfile(files, patched{k}), fullfile(root, patched{k}));
end

%--
% return to initial directory
%--

cd(p1);
