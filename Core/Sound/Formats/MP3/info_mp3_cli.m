function out = info_mp3_cli(f)

% info_mp3 - get sound file info
% ------------------------------
%
% info = info_mp3(f)
%
% Input:
% ------
%  f - file location
%
% Output:
% -------
%  info - format specific info structure

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

% TODO: add ID3 tag extraction, these can be put in the info info field

%--------------------------------------------------
% SET PERSISTENT VARIABLES
%--------------------------------------------------

persistent MP3INFO FLAG_TABLE INFO_FIELD;

if (isempty(MP3INFO))

	%--
	% set location of command-line helper
	%--
	
	% NOTE: consider a function 'mfilepath' to return the path
	
	MP3INFO = [fileparts(mfilename('fullpath')), filesep, 'mp3info.exe'];
	
	%--------------------------------------------------
	% create output string format table
	%--------------------------------------------------
	
	% NOTE: this is a useful subset of the allowed formating tokens
	
	FLAG_TABLE = { ...
		'bitrate',	'%r'; ...
		'duration', '%S'; ...
		'frames',	'%u'; ...
		'layer',	'%L'; ... 
		'samplerate', '%Q'; ...
		'stereo',	'%o'; ...
		'version',	'%v' ...
	};
	
	%--------------------------------------------------
	% set default info fields
	%--------------------------------------------------
	
	% NOTE: we only get some useful info fields by default
	
	INFO_FIELD = { ...
		'bitrate', ...
		'duration', ...
		'frames', ...
		'samplerate', ...
		'stereo', ...
		'version', ...
		'layer' ...
	};
		
end

%--------------------------------------------------
% GET FILE INFO
%--------------------------------------------------

%--
% create info format string
%--

% NOTE: this string formats describes the output using token replacement

str = '';

for k = 1:length(INFO_FIELD)
	
	ix = find(strcmp(INFO_FIELD{k},FLAG_TABLE(:,1)));
	str = [str, FLAG_TABLE{ix,2}, '::'];
	
end

%--
% get info using command-line utility
%--

cmd = ['"', MP3INFO, '" -r m -p "', str, '" "', f, '"'];

[status,info] = system(cmd);

if (status)
	error('invalid file');
end

%--
% handle error status
%--

% disp(['STATUS: ' int2str(status), ', ',info]);

%-----------------------------------------------
% PACK INFO STRUCTURE
%-----------------------------------------------

%--
% pack string results into structure array
%--

for k = 1:length(INFO_FIELD)
	[out.(INFO_FIELD{k}),info] = strtok(info,'::');
end

%--
% update the structure based on what we know about the fields
%--

for k = 1:length(INFO_FIELD)
		
	switch (INFO_FIELD{k})
		
		%--
		% fields simply converted to numbers
		%--
		
		case ({ ...
			'duration', ...
			'frames', ...
			'samplerate', ...
			'version' ...
		})
			
			out.(INFO_FIELD{k}) = eval(out.(INFO_FIELD{k}));
			
		%--
		% fields requiring more complex conversion
		%--
		
		case ({ ...
			'bitrate', ...
			'layer', ...
			'stereo' ...
		})
			
			value = lower(out.(INFO_FIELD{k}));
				
			switch (INFO_FIELD{k})
								
				case ('bitrate')
					
					% TODO: there are still some problems here
					
					try
						
						if (strcmp(value,'variable'))
							out.(INFO_FIELD{k}) = value;	
						else
							out.(INFO_FIELD{k}) = eval(value);
						end
					end
					
				case ('layer')
					
					out.(INFO_FIELD{k}) = length(value);
					
				case ('stereo')
					
					out.(INFO_FIELD{k}) = ~isempty(findstr(value,'stereo'));
					
			end
			
	end
				
end

%-----------------------------------------------
% CONVENIENCE FIELDS
%-----------------------------------------------

% NOTE: format only supports mono and stereo, the samplesize is always the same

out.channels = 2^out.stereo;

out.samplesize = 16;

out.format = ['MPEG ', num2str(out.version), ' layer ', int2str(out.layer)];

%-----------------------------------------------
% COMPUTED FIELDS
%-----------------------------------------------

%--
% number of samples per frame
%--

% NOTE: this is computed based on the version and layer

% REF: 'http://board.mp3-tech.org/view.php3?bn=agora_mp3techorg&key=1019510889'

if (out.layer == 1)
	
	out.samples_per_frame = 384;
	
elseif ((out.samplerate < 32000) && (out.layer == 3))
	
	out.samples_per_frame = 576;
	
	if (out.version == 1)
		disp(' ');
		error('Samplerate < 32000 but MPEG version = 1.');
	end
	
else
	
	out.samples_per_frame = 1152;
	
end

%--
% number of samples
%--

%--
% M.R. hack to get duration right...
%--

out.samples = out.frames * out.samples_per_frame;
