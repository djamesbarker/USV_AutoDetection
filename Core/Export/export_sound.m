function export_sound(lib,sound,root,view)

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
% EXPORT SOUND
%--------------------------------

% NOTE: sound name is computed

name = sound_name(sound);

%--
% create sound root directory
%--

sound_root = create_dir([root, filesep, name]);

if (isempty(sound_root))
	return;
end

%--
% create sound page
%--

% data.id = sound.id;

data.sound = sound;

out = 'index.html';

process_template(view,'sound',data,sound_root,out);

%--
% export sound logs
%--

% NOTE: this call gets log sound and name info, not actual logs

logs = get_library_logs('info',lib,sound)

logs = strcat(lib.path,logs,'.mat')

return;

for log = logs
	
	% TODO: get actual log using name
	
	export_log(log,root);
	
end
