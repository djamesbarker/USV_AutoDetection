function [result, context] = compute(event, parameter, context)

% CLIP - compute

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
% compute file name
%--

time = map_time(context.sound, 'real', 'record', event.time); 

% NOTE: try to use full datetime if possible

if ~isempty(context.sound.realtime)
    timestr = datestr((time(1) / 86400) + context.sound.realtime, 30);
else
    timestr = datestr(time(1) / 86400, 'HHMMSS.FFF');
end

ext = lower(parameter.format{1});

%--
% get event id string, padded with zeros
%--

idstr = int_to_str(event.id, 9999);

% NOTE: the clip file is the result

name = token_replace( ...
    parameter.file_names, file_name_tokens, {context.log, sound_name(context.sound), timestr, idstr} ...
);

result.file = [parameter.output, filesep, name, '.', ext];

%--
% write clip to file
%--

create_event_clip( ...
    context.sound, event, result.file, parameter.padding, parameter.taper ...
);





	
	



