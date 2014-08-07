function [out, D] = scan_to_flac(d1, d2, level, verb)

% scan_to_flac - scan directories and convert sound files
% -------------------------------------------------------
%
% out = scan_to_flac(in, out, level, verb)
%
% Input:
% ------
%  d1 - scan start directory (def: dialog)
%  out - converted output root directory (def: dialog)
%  level - compression level (def: 5)
%  verb - verbosity flag (def: 1)
%
% Output:
% -------
%  out - conversion information

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

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set default verbosity
%--

% NOTE: set this to 1 if the conversions are very long

if (nargin < 4) || isempty(verb)
	verb = 0;
end 

%--
% set default compression level
%--

if (nargin < 3) || isempty(level)
	level = 5;
end

%--
% set source directory
%--

if (nargin < 1) || isempty(d1)

	d1 = uigetdir(pwd, 'Select sound file source directory:');
	
	if ~d1
		out = []; return;
	end
	
end

%--
% set output directory
%--

if (nargin < 2) || isempty(d2)
	
	d2 = uigetdir(d1, 'Select sound file output directory:'); 
	
	if ~d2
		out = []; return;
	end

end

%---------------------------------------
% COPY DIRECTORY STRUCTURE
%---------------------------------------

% NOTE: this function handles restart gracefully

scan_copy_dir(d1, d2);

%---------------------------------------
% GET SOUND FILES
%---------------------------------------

%--
% scan directories for sound files
%--

% NOTE: at the moment we only convert 'WAV' and 'AIFF' files, copy 'FLAC'

ext1 = get_formats_ext(get_file_format('test.wav'));

ext2 = get_formats_ext(get_file_format('test.aif'));

ext3 = get_formats_ext(get_file_format('test.flac'));

% NOTE: we make simple but extensive use of comma-separated lists here 

ext = {ext1{:}, ext2{:}, ext3{:}};

out = scan_ext(d1, ext{:});

%---------------------------------------
% CONVERT SOUND FILES
%---------------------------------------

%--
% get location of CLI helper
%--

% NOTE: this is a clumsy way of getting the CLI helper location

FLAC = [fileparts(which('read_flac')), filesep, 'flac.exe'];

%--
% build template command string
%--

% NOTE: read on the implications of the 'lax' option

cmd_template = [ ...
	'"', FLAC, '" --lax --silent --compression-level-', int2str(level), ...
	' --output-name="OUTPUT_FILE" "INPUT_FILE"' ...
];

%--
% loop over directories containing sound files
%--

ix = 1;

for k = 1:length(out)
	
	%--
	% loop over extensions sought in scan
	%--
	
	for j = 1:length(ext)
		
		%--
		% get files with this extension
		%--
		
		files = out(k).(ext{j});
		
		if isempty(files)
			continue; 
		end 
		
		%--
		% perform file action, copy or encode
		%--
		
		switch (ext{j})
			
			%--
			% copy flac files
			%--
			
			case ext3
				
				for i = 1:length(files)

					%--
					% set input and output files
					%--
					
					f1 = [out(k).path, filesep, files{i}];
					
					f2 = strrep(f1, d1, d2);
					
					%--
					% copy files to output directory
					%--
					
					% NOTE: skip copy if file already exists
					
					t1 = clock;
					
					if ~exist(f2, 'file')		
						copyfile(f1, f2);
					end
					
					%--
					% store conversion information
					%--
					
					b1 = get_field(dir(f1), 'bytes');
					
					info(ix).path = out(k).path;
					
					info(ix).file = files{i};
					
					info(ix).bytes = b1;
					
					info(ix).out = f2;
					
					info(ix).time = etime(clock, t1);
					
					info(ix).compression = 1; % in this case we are just copying
					
					ix = ix + 1;
					
					%--
					% display progress
					%--
					
					if verb
						disp(sprintf(to_xml(info(ix - 1))));
					end
					
				end
			
			%--
			% encode other files
			%--
			
			otherwise
	
				for i = 1:length(files)
					
					%--
					% set input and output files
					%--
					
					f1 = [out(k).path, filesep, files{i}];
					
					f2 = [file_ext(strrep(f1, d1, d2)), '.flac'];
					
					%--
					% build and execute command string
					%--
					
					t1 = clock;
					
					% NOTE: skip encode if file already exists
					
					if ~exist(f2, 'file')
					
						cmd_str = strrep(strrep(cmd_template, 'INPUT_FILE', f1), 'OUTPUT_FILE', f2);

						system(cmd_str);
						
					end

					%--
					% store conversion information
					%--
					
					% NOTE: sometimes dir does not output a structure in this calling context
					
					b1 = get_field(dir(f1), 'bytes');
					
					b2 = get_field(dir(f2), 'bytes');
					
					info(ix).path = out(k).path;
					
					info(ix).file = files{i};
					
					info(ix).bytes = b1;
					
					info(ix).out = f2;
					
					info(ix).time = etime(clock, t1); 
					
					info(ix).compression = b1 / b2; 
					
					ix = ix + 1;
					
					%--
					% display progress
					%--
					
					if verb
						disp(sprintf(to_xml(info(ix - 1))));
					end
				
				end
				
		end
		
	end

end

%--
% return conversion information as output
%--

out = info;

	
