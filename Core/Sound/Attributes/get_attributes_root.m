function root = get_attributes_root(context)

% get_attributes_root - get attributes directory relative to input path
% ---------------------------------------------------------------------
%
% root = get_attributes_root(context)
% 
% Input:
% ------
%  context - context (includes sound and container library)
%
% Output:
% -------
%  root - attributes path

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


% NOTE: also check that we can write with the sound? perhaps create_dir,
% except that it may exist in non-writeable media, which if it contains the
% attributes means we cannot edit them???


%--
% handle sound input
%--

% NOTE: placing attributes with the data provides universal access

if strcmpi(context.sound.type, 'file stream')	
	root = [context.sound.path, filesep, '__XBAT', filesep, 'Attributes'];
else
	root = fullfile(context.library.path, sound_name(context.sound), 'Attributes');
end
