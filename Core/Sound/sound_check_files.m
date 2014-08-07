function out = sound_check_files(sound)

% sound_check_files - check that all files for a given sound exist
% ----------------------------------------------------------------
%  out = sound_check_files(sound)
%
% Input:
% ------
%  sound - the sound
%
% Output:
% -------
%  out - true if all files exist

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

out = 1;

if ismember(sound.type, {'variable', 'recording', 'synthetic'})
	return;
end

%--
% check that sound files exist in the same location
%--

if iscell(sound.file)
	
	%--
	% check all files in sound
	%--
	
	for k = 1:length(sound.file)		
		test(k) = exist([sound.path, sound.file{k}], 'file');
	end
	
else
	
	%--
	% check single sound file
	%--
		
	test = exist([sound.path, sound.file], 'file');
	
end

%--
% find the sound files and reassign if needed
%--

out = all(test == 2);

	
