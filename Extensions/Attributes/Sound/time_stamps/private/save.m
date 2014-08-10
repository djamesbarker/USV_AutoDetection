function save(attribute, store, context)

% TIME_STAMPS - save

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

lines{1} = 'sound time, stamp time';

lines{2} = 'stamps';

table = attribute.table;

for k = 1:size(table, 1)	
	lines{end + 1} = [num2str(table(k, 1),'%.17f'), ', ' num2str(table(k, 2),'%.17f')];
end

file_writelines(store, lines);

%--
% save configuration options
%--

sound = context.sound;

sound.time_stamp = attribute;

sound_save(context.library, sound, get_sound_state(sound, context.library));
