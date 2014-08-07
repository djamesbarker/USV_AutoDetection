function [info, pal, err] = get_file_info(p, f)

% get_file_info - get sound file info and check for consistency
% -------------------------------------------------------------
%
% [info, pal] = get_file_info(p, f)
%
% Input:
% ------
%  p - path to files
%  f - files
%
% Output:
% -------
%  info - sound file info
%  pal - palette handle

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

err = '';

%---------------------------
% FILE
%---------------------------
	
if ischar(f)
	info = sound_file_info([p, f]); pal = []; return;
end

%---------------------------
% FILE LIST
%---------------------------

%--
% set test fields and error prefix
%--

test_field = { ...
	'samplerate', ...
	'channels', ...
	'samplesize', ...
	'format' ...
};

str = ['Files in ''' p ''' do not have matching '];

%--
% create waitbar
%--

pal = sound_create_wait;

listbox = findobj(pal, 'tag', 'Files', 'style', 'listbox');

%--
% get sound file info incrementally
%--

N = length(f);

base = [];

for k = 1:N

	%--
	% update waitbar
	%--

	waitbar_update(pal,'PROGRESS', ...
		'value', k/N, 'message', ['Adding file ''' f{k} ''''] ...
	);

	%--
	% get sound file info
	%--
	
	info_k = sound_file_info([p, f{k}]);
		
	if isempty(info_k)
		
		info = []; close(pal);
		
		[ignore, name] = fileparts(fileparts(p));
		
		disp(['The sound "', name, '" seems to have a corrupt file: ', p, f{k}]);

		return;
	
	end
	
	info(k) = info_k;

	for j = 1:length(test_field)

		if ~isequal(info(1).(test_field{j}),info(k).(test_field{j}))

			close(pal); info = []; 

			err = [str, test_field{j}, '.'];
			
			return;
			
		end

	end

	%--
	% update file list display on waitbar
	%--

	k1 = max(k - 20,1); 
	
	txt = f(k1:k); 
	
	val = length(txt);

	set(listbox, ...
		'string',txt, ...
		'value',val ...
	);

end


%------------------------------------------------------------------------
% SOUND_CREATE_WAIT
%------------------------------------------------------------------------

function h = sound_create_wait(name)

% sound_create_wait - create sound creation waitbar
% -------------------------------------------------
%
% h = sound_create_wait(name)
%
% Input:
% ------
%  sound - sound structure

% NOTE: this is only used while creating multiple file sound structures

%-----------------------------
% WAITBAR CONTROLS
%-----------------------------

%--
% progress waitbar
%--

control = control_create( ...
	'name','PROGRESS', ...
	'alias','Create Sound ...', ...
	'style','waitbar', ...
	'confirm',1, ...
	'lines',1.1, ...
	'space',2 ...
);

control(end + 1) = control_create( ...
	'style','separator', ...
	'type','header', ...
	'string','Details' ...
);

control(end + 1) = control_create( ...
	'name','Files', ...
	'alias','Files', ...
	'lines',6, ...
	'space',0, ...
	'confirm',0, ...
	'style','listbox' ...
);

%-----------------------------
% CREATE WAITBAR
%-----------------------------

% NOTE: the title does not match the function, 'get folder sounds' and 'add sounds' 

name = ['Create Sound ...'];

%--
% check for possible parent
%--

opt = waitbar_group; opt.show_after = 1;

par = get_xbat_figs('type','waitbar');

if (numel(par) == 1)
	h = waitbar_group(name,control,par,'bottom',opt); return;
end

h = waitbar_group(name,control,[],[],opt);
