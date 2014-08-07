function S = sound_info_str(sound, fields)

% sound_info_str - create string cell array with sound info
% ---------------------------------------------------------
%
% S = sound_info_str(sound, fields)
%
% Input:
% ------
%  sound - sound to get info from
%  fields - sound fields to display
%
% Output:
% -------
%  S - cell array of info strings

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
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

if numel(sound) > 1 
	fields = 'multiple';
elseif nargin < 2
	fields = [];
end

%--
% set default fields
%--

if nargin < 2 && isempty(fields)
	
	%--
	% set generic display fields
	%--
	
	fields = { ...
		'channels', ...
		'realtime', ... 
		'duration', ...
		'samplerate', ...
		'bitrate', ...
		'created', ...
		'modified' ...
	};

	%--
	% remove fields based on sound info
	%--

	% TODO: rename realtime to datetime, this name is used in other places

	if isempty(sound.modified)
		fields(end) = [];
	else
		fields(end - 1) = [];
	end
	
	if isempty(sound.realtime)
		fields(2) = [];
	end

end

if strcmp(fields, 'multiple')
	
	bytes = get_sound_bytes(sound);
	
	[bytes, unit] = get_unit_bytes(sum(bytes));
	
	S = [ ...
		integer_unit_string(numel(sound), 'sound'), ', ' ...
		duration_string(sum(get_sound_duration(sound))), ', ' ...
		integer_unit_string(bytes, upper(unit), 0) ...
	]; 
	
	return;
	
end

%-----------------------------------------------------
% CREATE INFO STRING CELL
%-----------------------------------------------------

%----------------------------
% NAME
%----------------------------

% NOTE: name is a computed field

S = {['Sound:  ' sound_name(sound)]};

%----------------------------
% OTHER FIELDS
%----------------------------

for k = 1:length(fields)
	
	%--
	% skip non field fields and empty fields
	%--
	
	if ~isfield(sound, fields{k}) && ~isfield(sound.info, fields{k})
		continue;
	end
	
	%--
	% create label section of string
	%--
	
	% TODO: implement some kind of 'alias' mechanism to change the field names
	
	str = [title_caps(fields{k},'_'), ':  '];
	
	%--
	% handle empty fields
	%--
	
	if isfield(sound, fields{k}) && isempty(sound.(fields{k}))
		
		str = [str, '(Not Available)']; 
		
		S{end + 1} = str; continue;
		
	end
	
	%--
	% handle non empty fields
	%--
	
	% NOTE: if we could attach a to string method to each fields this would be trivial
	
	switch fields{k}
		
		%--
		% realtime
		%--
		
		% TODO: this should be called 'datetime' throughout
		
		% TODO: wrap 'datestr' so we can set conversion option globally
		
		case ('realtime')
			
			% TODO: this code will be used when we move fully to attributes
			
% 			attr = get_sound_attribute(sound, 'date_time');
% 			
% 			if isempty(attr)
% 				continue;
% 			end
			
			S{end + 1} = ['Datetime:  ', datestr(sound.realtime)];
			
		%--
		% duration
		%--
		
		% NOTE: duration is displayed as clock
		
		case ('duration')
			
			data_duration = sound.duration;
            sound_duration = get_sound_duration(sound);
			
			if (data_duration == sound_duration)
				S{end + 1} = [str, sec_to_clock(sound_duration)];
			else
				S{end + 1} = [str, sec_to_clock(sound_duration), '  (', sec_to_clock(data_duration), ')'];
			end
							
		%--
		% samplerate
		%--

		% NOTE: samplerate is displayed in 'Hz'
		
		case ('samplerate')
			
			rate = get_sound_rate(sound);
			
			if (rate ~= sound.samplerate)
				S{end + 1} = [str, num2str(rate) ' Hz  (', num2str(sound.samplerate), ' Hz)']; 
			else
				S{end + 1} = [str, num2str(sound.samplerate) ' Hz'];
			end
			
		%--
		% bitrate
		%--
		
		case 'bitrate'
			
			S{end + 1} = [str, int2str(sound.info.bitrate), ' kbps'];
			
			if isfield(sound.info, 'vbr') && sound.info.vbr
				S{end} = [S{end}, ' (VBR)'];
			end
			
		%--
		% samplesize
		%--
		
		case ('samplesize')
						
			S{end + 1} = [str, int2str(sound.samplesize)];
			
		%--
		% created and modified
		%--
		
		case ({'created','modified'})
			
			S{end + 1} = [str, datestr(sound.(fields{k}))];
			
		%--
		% other fields
		%--
		
		% NOTE: display is based on value type evaluation
		
		otherwise

			%--
			% get field value and produce display
			%--
			
			value = sound.(fields{k});
					
			% NOTE: only strings and scalar numeric arrays are displayed
			
			if (ischar(value))
				
				str = [str, value];
				
			elseif (isnumeric(value) && (length(value) == 1))
				
				if (round(value) == value)
					str = [str, int2str(value)];
				else
					str = [str, num2str(value)];
				end
				
			end
			
			S{end + 1} = str;
			
		end 
		
	end
	
end
