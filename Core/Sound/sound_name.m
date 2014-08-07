function name = sound_name(sound)

% sound_name - compute name of sound
% ----------------------------------
%
% name = sound_name(sound)
%
% Input:
% ------
%  sound - sound structure
%
% Output:
% -------
%  name - string used as name for sound

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
% $Revision: 5888 $
% $Date: 2006-08-01 13:44:20 -0400 (Tue, 01 Aug 2006) $
%--------------------------------

% NOTE: this function encodes sound file naming conventions used

%-------------------------------------------------
% CHECK INPUT
%-------------------------------------------------

%--
% return quickly on empty
%--

if isempty(sound)
	name = []; return;
end

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% handle sound structure arrays recursively
%--

if length(sound) > 1
	
	for k = 1:length(sound)
		name{k} = sound_name(sound(k));
	end
	
	return;
	
end

%-------------------------------------------------
% COMPUTE SOUND NAME
%-------------------------------------------------

switch lower(sound.type)

	%--
	% file
	%--
	
	case 'file'

		% TODO: handle file names with channel indices in special way
		
		% NOTE: the sound name the filename without the extension

		name = file_ext(sound.file);

	%--
	% file stream
	%--
	
	case 'file stream'

		% NOTE: the sound name is the immediate parent directory name
		
		name = file_parent(sound.path,0);
		
		%--
		% check for channel naming convention 
		%--
		
		% TODO: create a function to handle more complex conventions
		
		channels = 0;
		
		if (strcmpi(name(1:2),'ch'))
			channels = 1; 
		end
		
		if (channels)
			name = [file_parent(sound.path), ' Ch ', strtrim(name(3:end))];
		end
		
% 		%--
% 		% handle name length
% 		%--
% 		
% 		if (length(name) < 10)
% 			
% 			if (channels)			
% 				name = [file_parent(sound.path,2), ', ', name];
% 			else
% 				name = [file_parent(sound.path), ', ', name];
% 			end
% 			
% 		end
		

	
	case ('stack')
		
		name = 'stacked sound';
		
		
	case {'variable', 'synthetic'}
		
		name = sound.file;
		
	%--
	% error condition
	%--
	
	otherwise
	
		error(['Unrecognized sound type ''' sound.type '''.']);

end
