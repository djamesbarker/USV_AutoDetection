function out = export_log(log, opt, top_dir)

% export_log - export log to external format
% ------------------------------------------
%
% opt = export_log
%
% out = export_log(log, opt, out)
%
% Input:
% ------
%  log - log to export
%  opt - log export options
%  out - directory to export into
%
% Output:
% -------
%  opt - exporting options
%  out - export information

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
% $Date: 2006-08-28 18:03:45 -0400 (Mon, 28 Aug 2006) $
% $Revision: 6335 $
%--------------------------------

%-----------------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------------

%--
% get parent directory for export
%--

% NOTE: the immediate parent export directory is named as the log

if (nargin < 3) || isempty(top_dir)
	
	top_dir = uigetdir;

	if (~top_dir)
		out = []; return;
	end

end

%--
% set default options
%--

if ((nargin < 2) || isempty(opt))
	
	%------------------
	% TEXT OPTIONS
	%------------------
	
	% TODO: implement the various forms of text output
	
	% NOTE: allowed values are 'xml', 'html', 'text', and 'all'
	
	opt.text.create = 'all'; 
	
	%------------------
	% CLIP OPTIONS
	%------------------
		
	opt.clip.create = 1;
	
	% TODO: allow for a template language string here
	
	opt.clip.filename = '';
	
	opt.clip.pad_mode = 'data';
	
	opt.clip.pad_time = 0.5;
	
	opt.clip.pad_fade = 0.5;
	
	opt.clip.samplerate = [];
		
	opt.clip.format = [];
		
	opt.clip.format_opt = [];
	
	%------------------
	% IMAGE OPTIONS
	%------------------
	
	% TODO: the colormap structure should be reviewed and non-floating limits added
	
	opt.image.create = 1;
	
	opt.image.colormap = [];
		
	opt.image.box_edge = 1;
	
	opt.image.box_alpha = 0;
	
	% TODO: allow format specific encoding options
	
	opt.image.format = 'jpg';
	
	opt.image.format_opt = [];

	%--
	% output options
	%--
	
	if (~nargin)
		out = opt; return;
	end
	
end

%-----------------------------------------------------------
% EXPORT LOG
%-----------------------------------------------------------

%--
% create export waitbar
%--

% NOTE: the waitbar is aware of the export options

hw = export_waitbar(log,opt);

%--
% remove empty events
%--

% NOTE: this should not be needed, consider issuing a warning

for k = length(log.event):-1:1
	
	% NOTE: check for an empty id
	
	if (isempty(log.event(k).id))
		log.event(k) = [];
	end
	
end

%------------------------------------
% CREATE DIRECTORIES
%------------------------------------

% NOTE: this is best done by using the same organization as the library

%--
% create parent sound directory
%--

name = sound_name(log.sound);

% NOTE: using 'mkdir' with two output arguments suppresses the warning

[flag,msg] = mkdir(top_dir,name);

top_dir = [top_dir, filesep, name];

%--
% create log directory
%--

% NOTE: create a new directory in the case that one already exists

name = file_ext(log.file);

[flag,msg] = mkdir(top_dir,name);

k = 2;

while (~isempty(strfind(msg,'already exists')))
	
	name = [file_ext(log.file), ' (' int2str(k) ')'];
	
	[flag,msg] = mkdir(top_dir,name);
	
	k = k + 1;
	
end

%--
% set output directory
%--

out_dir = [top_dir, filesep, name];

%------------------------------------
% CREATE CLIP NAMES
%------------------------------------

% NOTE: the clip and image filenames correspond

[clip_names,event_codes] = event_filenames(log,opt.clip.filename);

%------------------------------------
% CREATE CLIPS
%------------------------------------

%--
% set and create clip output directory
%--
	
if (opt.clip.create)
	
	% NOTE: the log name is included to make viewing clips as sound easier
	
	[flag,msg] = mkdir(out_dir,[name, ' Clips']);
	
	clip_dir = [out_dir, filesep, name, ' Clips'];
	
end

%--
% create clips in output directory if needed
%--
	
if (opt.clip.create || opt.image.create)
				
	[clips,temp_clips] = create_clips( ...
		log, clip_dir, clip_names, hw, opt ...
	);
		
end

%------------------------------------
% CREATE IMAGES
%------------------------------------

% NOTE: we create images after clips to use padded clips

if (opt.image.create)
		
	%--
	% create image directory
	%--
	
	mkdir(out_dir,[name, ' Images']);
	
	image_dir = [out_dir, filesep, name, ' Images'];
	
	%--
	% create clip images
	%--
		
	[clip_images,image_sizes] = create_clip_images( ...
		log, image_dir, clip_names, hw, opt, temp_clips ...
	);
	
end

%------------------------------------
% DELETE FILES
%------------------------------------

%--
% delete temp clips if needed
%--

% NOTE: in the case of WAV clip files the temp files are the output

[ignore,ext] = file_ext(clips{1});

if (~strcmpi(ext,'wav'))
	
	% NOTE: this can be done at the system level

	for k = 1:length(temp_clips)
		delete(temp_clips{k});
	end

end

%--
% delete clips if needed
%--

if (~opt.clip.create)
	
	% NOTE: this can be done at the system level

	for k = 1:length(clips)
		delete(clips{k});
	end
	
end

%------------------------------------------
% EXPORT LOG EVENT TEXT
%------------------------------------------

% TODO: provide a simple form of output in the meantime to provide document interface to output

% NOTE: since we are elevating the simple annotation to a privileged status hard code it's export

%--
% create and open output file
%--

fid = fopen([out_dir, filesep, name, '.html'],'w');

if (~fid)
	
	disp(' '); warning('Unable to create text output.');
	
else
	
	%------------------------------------------
	% HEADER
	%------------------------------------------
	
	% NOTE: there is a better way to do this
	
	str = '';
	str = [str, '<HTML>\n\n<HEAD>\n\n'];
	str = [str, '<TITLE>', sound_name(log.sound), ' / ', name, '</TITLE>\n'];
	
	str = [str, '<LINK rel="stylesheet" href="Clips.css" type="text/css">\n'];
	str = [str, '<SCRIPT language = javascript src="Clips.js"></SCRIPT>\n\n'];
	
	% NOTE: add style on image display based on image asepct ratio
	
	M = max(image_sizes,[],1);
	
	if (M(1) > M(2))
		str = [str, '<STYLE>IMG.clip {height: 128px}</STYLE>\n\n'];
	else
		str = [str, '<STYLE>IMG.clip {width: 128px}</STYLE>\n\n'];
	end
	
	str = [str, '</HEAD>\n\n<BODY>\n\n'];

	fprintf(fid,str);

	%------------------------------------------
	% CLIPS CONTROLS
	%------------------------------------------
	
	% TODO: add other controls
	
	str = '';
	str = [str, '<DIV class = "clips_controls">\n'];
	str = [str, '<TABLE width = "100%%">\n<TR><TD align = "left">\n'];
	str = [str, '<INPUT type = "checkbox" id = "code_toggle" onClick = "javascript:code_toggle();" CHECKED>Code</INPUT>\n'];
	str = [str, '</TD></TR><TR><TD align = "left">\n'];
	str = [str, '<INPUT type = "checkbox" id = "info_toggle" onClick = "javascript:info_toggle();">Event Info</INPUT>\n'];
	str = [str, '</TD></TR></TABLE>\n'];
	str = [str, '</DIV>\n'];
	
	fprintf(fid,str);
	
	%------------------------------------------
	% CLIPS PANE
	%------------------------------------------
	
	str = ['<DIV class = "clips_pane"><TABLE class = "clips_table">\n'];
	
	fprintf(fid,str);
	
	%------------------------------------------
	% EVENT TEXT
	%------------------------------------------
	
	%--
	% compute link prefix and suffix
	%--
	
	img_pre = ['./', name, ' Images/'];
	
	[ignore,img_ext] = file_ext(clip_images{1}); img_ext = ['.', img_ext];
	
	snd_pre = ['./', name, ' Clips/'];
	
	[ignore,snd_ext] = file_ext(clips{1}); snd_ext = ['.', snd_ext];
	
	%--
	% loop over events
	%--
	
	NUM_COL = 4;
		
	for k = 1:length(log.event)
		
		%------------------------------------------
		% CREATE TOKEN STRINGS
		%------------------------------------------
		
		id_str = int2str(log.event(k).id);
		
		title_str = [name, ' # ', id_str];
		
		img_src = [img_pre, clip_names{k}, img_ext];
		
		snd_src = [snd_pre, clip_names{k}, snd_ext];
		
		% NOTE: this javascript function is found in the 'Clips.js' file
		
		x_str = int2str(image_sizes(k,2)); y_str = int2str(image_sizes(k,1));
		
		js_cmd = [ ...
			'javascript:popup_clip(''', title_str, ''',', ...
			'''', snd_src, ''',', ... 
			'''', img_src, ''',', x_str, ',', y_str, ...
			');' ...
		];
		
		%------------------------------------------
		% CREATE EVENT MARKUP
		%------------------------------------------
		
		%--
		% start table entry and row if needed
		%--
		
		if (mod(k,NUM_COL) == 1)
			str = ['<TR>\n<TD>\n'];
		else
			str = ['<TD>\n'];
		end

		%--
		% start event div
		%--
		
		str = [str, '<DIV class = "event" id = ' id_str '>\n'];
		
		%--
		% display title and code if needed
		%--
		
		str = [str, '<SPAN class = "title">', title_str, '</SPAN>\n'];
		
		if (~isempty(event_codes{k}))
			str = [str, '<SPAN class = "code_container" <SPAN class = "code">', event_codes{k}, '</SPAN></SPAN>\n'];
		end
		
		%--
		% display event clip image
		%--
				
		% TODO: image click opens window with actual size image and play
		
		str = [str, '<DIV class = "clip">\n<A href="', js_cmd, '">\n\t<IMG class = "clip" src="', img_src, '">\n</A>\n</DIV>\n'];
		
% 		str = [str, '<DIV class = "clip">\n<A href="', snd_src, '"><IMG class = "clip" src="', img_src, '"></A>\n</DIV>\n'];
		
		%--
		% display event information text
		%--
		
		% NOTE: this is the same text that is used in the event palette
		
		info_str = event_info_str(name,log.event(k),log.sound);
		
		str = [str, '<DIV class = "info_container">\n<DIV class = "info">\n'];
		
		for j = 1:length(info_str)
			str = [str, '\t', info_str{j}, '</BR>\n'];
		end
		
		str = [str, '</DIV>\n</DIV>\n'];
		
		%--
		% end event div
		%--
		
		str = [str, '</DIV>\n\n'];
		
		%--
		% end table entry and row if needed
		%--
				
		if (mod(k,NUM_COL) == 0)
			str = [str, '</TD>\n</TR>\n'];
		else
			str = [str, '</TD>\n'];
		end
		
		%--
		% write to file
		%--
		
		fprintf(fid,str);
		
	end
	
	%--
	% end table
	%--
	
	str = ['</TABLE></DIV>\n'];
	
	%------------------------------------------
	% WRITE EVENT MARKUP TO FILE
	%------------------------------------------
	
	fprintf(fid,str);
	
end

%--
% end markup
%--

str = ['</BODY>\n\n</HTML>\n\n'];

fprintf(fid,str);

%--
% close file
%--

fclose(fid);

%--
% copy style and javascript to directory
%--

% tmp = fileparts(which('export_log'));

tmp = [xbat_root, filesep, 'Core', filesep, 'Web'];

copyfile([tmp, filesep, 'Clips.css'],out_dir);

copyfile([tmp, filesep, 'Clips.js'],out_dir);

% %--
% % flatten measurement parameters and values
% %--
% 
% for k = 1:length(log.event)
% 	
% 	for j = length(log.event(k).measurement):-1:1
% 		
% 		% NOTE: skip empty placeholder measurements
% 		
% 		if (isempty(log.event(k).measurement(j).name))
% 			continue;
% 		end
% 		
% 		%--
% 		% flatten parameter and value structures
% 		%--
% 		
% 		log.event(k).measurement(j).parameter = ...
% 			flatten_struct(log.event(k).measurement(j).parameter);
% 		
% 		log.event(k).measurement(j).value = ...
% 			flatten_struct(log.event(k).measurement(j).value);
% 
% 	end
% 	
% end

% NOTE: this is the part of the framework that requires most work

% %--
% % convert log to xml
% %--
% 
% xml_to_file(to_xml(log,'LOG'),[out_dir filesep name '.xml']);
% 
% %--
% % apply required xml transformations to get other types
% %--
% 
% switch (opt.output)
% 		
% 	case ('all')
% 		
% 	case ('html')
% 		
% 	case ('text');
% 		
% 	case ('xml')
% 		
% 	otherwise
% 		
% end

%--
% close waitbar
%--

[ignore,value] = control_update([],hw,'close_confirm');

if (value)
	delete(hw);
end


%---------------------------------------------------------------------
% CREATE_CLIPS
%---------------------------------------------------------------------

% NOTE: if this function was to become independent it's calling form should change

function [clips,temp_clips] = create_clips(log,out_dir,clip_names,hw,opt)

% create_clips - create event clips and clip images
% -------------------------------------------------
%
% clips = create_clips(log,out_dir,clip_names,hw,opt)
%
% Input:
% ------
%  log - input log
%  out_dir - location for clip files
%  clip_names - event part of clip filenames
%  hw - handle to waitbar
%  opt - export options (includes clip creations options)
%  
% Output:
% -------
%  clips - created clip files
	
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2006-08-28 18:03:45 -0400 (Mon, 28 Aug 2006) $
% $Revision: 6335 $
%--------------------------------

%--------------------------------------
% GET INPUT AND OUTPUT FORMAT
%--------------------------------------

%--
% get clip format from original sound files
%--

sound = log.sound;

if (strcmp(sound.type,'File'))
	tmp = sound.file;
else
	tmp = sound.file{1};
end

[ignore,ext] = file_ext(tmp);

%--
% set output sound format
%--

% TODO: make this an export option

% NOTE: flac and ogg are not currently supported by the QuickTime browser plugin

% NOTE: there are problems with the MP3 support

if (strcmpi(ext,'flac') || strcmpi(ext,'ogg'))
	ext_out = 'wav';
else
	ext_out = ext;
end

%--------------------------------------
% CREATE CLIP FILENAMES
%--------------------------------------

%--
% create full filename prefix (includes directory)
%--

% NOTE: uncompressed files are used to create the images

temp_clips = strcat(out_dir,filesep,clip_names,'.wav');

%--------------------------------
% LOOP OVER EVENTS
%--------------------------------

event = log.event;

for k = 1:length(event)
	
	%--------------------------------
	% READ EVENT DATA
	%--------------------------------
		
	X = sound_read(sound, ...
		'time', event(k).time(1), diff(event(k).time), event(k).channel ...
	);
	
	%--------------------------------
	% PAD EVENT DATA
	%--------------------------------
	
	% TODO: make this a separate function
	
	if (opt.clip.pad_time)
		
		switch (opt.clip.pad_mode)
			
			%--
			% zero padding
			%--
			
			case ('zero')
				
				%--
				% set start and end padding
				%--
				
				L = zeros(round(sound.samplerate * opt.clip.pad_time),1);
				
				R = zeros(round(sound.samplerate * opt.clip.pad_time),1);
				
			%--
			% data padding with fading
			%--
			
			% NOTE: we don't handle running off the edges of the sound in the best way
			
			case ('data')

				%--
				% consider pad time and fade
				%--

				dt = opt.clip.pad_time * opt.clip.pad_fade;

				dz = opt.clip.pad_time - dt;

				%--
				% get start padding
				%--

				if ((event(k).time(1) - dt) > 0)

					%--
					% get samples in fade part and fade
					%--

					L = sound_read(sound, ...
						'time',event(k).time(1) - dt,dt,event(k).channel ...
					);

					L = (linspace(0,1,length(L)).^2)' .* L;

					%--
					% add zeros samples if needed
					%--

					if (dz)
						L = [zeros(round(sound.samplerate * dz),1); L];
					end

				else

					L = zeros(round(sound.samplerate * opt.clip.pad_time),1);

				end

				%--
				% get end padding
				%--

				if ((event(k).time(1) + dt) < sound.duration)

					%--
					% get samples in fade part and fade
					%--

					R = sound_read(sound, ...
						'time',event(k).time(2),dt,event(k).channel ...
					);

					R = (linspace(1,0,length(R)).^2)' .* R;

					%--
					% add zeros samples if needed
					%--

					if (dz)
						R = [R; zeros(round(sound.samplerate * dz),1)];
					end

				else

					L = zeros(round(sound.samplerate * opt.clip.pad_time),1);

				end
				
		end

		%--
		% pad event data
		%--
		
		X = [L; X; R];
	
	end
	
	%--------------------------------
	% write event clip file
	%--------------------------------
					
	% NOTE: this function will assume data is in the -1 to 1 range
	
	sound_file_write(temp_clips{k}, X, sound.samplerate);
		
	%--
	% update waitbar
	%--
	
	% TODO: this update will change, also set slower update rate
		
	if (opt.image.create)
		waitbar_update(hw,'PROGRESS','value',k / (2 * length(event)));
	else
		waitbar_update(hw,'PROGRESS','value',k / length(event));
	end
	
end

%--------------------------------
% encode directory if needed
%--------------------------------

if (strcmpi(ext_out,'wav'))
	clips = temp_clips; return;
end

clips = strcat(out_dir,filesep,clip_names,'.',ext_out);

for k = 1:length(clips)	
	out = sound_file_encode(temp_clips{k},clips{k},[]);
end


%---------------------------------------------------------------------
% CREATE_CLIP_IMAGES
%---------------------------------------------------------------------

% NOTE: if this function was to become independent it's calling form should change

function [clip_images,sizes] = create_clip_images(log,out_dir,clip_names,hw,opt,clips)

% create_clip_images - create event clips and clip images
% -------------------------------------------------
%
% clip_images = get_clip_images(log,out_dir,hw,opt,clips)
%
% Input:
% ------
%  log - input log
%  out_dir - location for clip image files]\
%  clip_names - partial event filenames
%  hw - handle to waitbar
%  opt - export options (includes image export options)
%  clips - filenames for clips
%  
% Output:
% -------
%  clip_images - created clip image files
	
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2006-08-28 18:03:45 -0400 (Mon, 28 Aug 2006) $
% $Revision: 6335 $
%--------------------------------

%--------------------------------------
% INITIALIZATION
%--------------------------------------

%--
% create clip image filenames
%--
	
clip_images = strcat(out_dir,filesep,clip_names,'.jpg');

sizes = zeros(length(clip_images),2);

%--
% configure event display as mask
%--

mask_opt = mask_gray_color;

mask_opt.bound = 1;

mask_opt.color = log.color;

%--
% get spectrogram resolution
%--

dt = (log.sound.specgram.fft * log.sound.specgram.hop) / ...
	log.sound.samplerate;

df = log.sound.samplerate / log.sound.specgram.fft;
		
%--
% set colormap
%--

% NOTE: the colormap should be obtained from the view

map = flipud(gray(512));

%--------------------------------------
% CREATE IMAGE FILES
%--------------------------------------

event = log.event;

for k = 1:length(event)
	
	%--------------------------------
	% READ EXPORTED CLIP DATA
	%--------------------------------
					
	X = sound_file_read(clips{k});
		
	%--------------------------------
	% COMPUTE SPECTROGRAM
	%--------------------------------
		
	X = fast_specgram(X,log.sound.samplerate,'norm',log.sound.specgram);

	%--
	% flip and scale image values
	%--
	
	X = lut_dB(flipud(X));
		
	sizes(k,:) = size(X);
	
	%--------------------------------
	% PREPARE SPECTROGRAM AS IMAGE
	%--------------------------------
	
	% TODO: use this same idea for the event browser to produce better displays
	
	%--
	% create scaled colormap RGB image
	%--
	
	% NOTE: each spectrogram is automatically scaled and converted to RGB
	
	C = cmap_scale([],X,map);
	
	X = gray_to_rgb(X,C);
	
	%--
	% display event as mask
	%--
			
	if (opt.image.box_edge)
			
		%--
		% compute event rectangle in pixel coordinates
		%--
		
		% NOTE: clip start time is zero
		
		x1 = opt.clip.pad_time / dt; 
		x1 = max(floor(x1),1);
		
		x2 = (diff(event(k).time) + opt.clip.pad_time) / dt;
		x2 = ceil(x2);
		
		y1 = event(k).freq(1) / df;
		y1 = max(floor(y1),1);
		
		y2 = event(k).freq(2) / df;
		y2 = ceil(y2);
		
		%--
		% create event mask
		%--
				
		Z = zeros(size(X,1),size(X,2));
		
		Z(y1:y2,x1:x2) = 1;
				
		Z = flipud(Z);
				
		%--
		% add mask to image
		%--
		
		X = mask_gray_color(X,Z,mask_opt);
		
	end
	
	%--------------------------------
	% WRITE IMAGE TO FILE
	%--------------------------------
		
	% NOTE: convert image to uint8 ourselves, 'imwrite' takes too long doing the same
	
	X = uint8(lut_range(X,[0,255]));
	
	imwrite(X,clip_images{k});
	
	%--
	% waitbar update
	%--
	
	% NOTE: this update will change
	
	if (opt.clip.create)
		waitbar_update(hw,'PROGRESS','value',0.5 + (k / (2 * length(event))));
	else
		waitbar_update(hw,'PROGRESS','value',k / length(event));
	end
	
end


%---------------------------------------------------------------------
% EVENT_FILENAMES
%---------------------------------------------------------------------

function [clip_names,event_codes] = event_filenames(log,format)

% event_filenames - create clip filenames using format string
% ----------------------------------------------------------
%
% [clip_names,event_codes] = event_filenames(log,format)
%
% Input:
% ------
%  log - export log 
%  format - format string
%
% Output:
% -------
%  clip_names - event filename strings
%  event_codes - event code strings

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2006-08-28 18:03:45 -0400 (Mon, 28 Aug 2006) $
% $Revision: 6335 $
%--------------------------------

%--
% get events
%--

event = log.event;

n = length(event);

%--
% create id strings for filenames
%--

id = struct_field(event,'id');

id_str = int_to_str(id);

M = length(int_to_str(max(id)));

Z = double('0');

for k = 1:n
	if (length(id_str{k}) < M)
		id_str{k} = [char(Z * ones(1,M - length(id_str{k}))), id_str{k}];
	end
end

%--
% create filenames using log name and evnet id
%--

clip_names = strcat(file_ext(log.file),'_',id_str);

%--
% get code strings and add to filenames if needed
%--

for k = 1:n
	
	if ( ...
		~isempty(event(k).annotation.name) && ...
		~isempty(event(k).annotation.value.code) ...
	)

		event_codes{k} = event(k).annotation.value.code;
		clip_names{k} = [clip_names{k}, ' (', event_codes{k}, ')'];

	else
		
		event_codes{k} = '';
		
	end
	
end


%---------------------------------------------------------------------
% EXPORT_WAITBAR
%---------------------------------------------------------------------

function h = export_waitbar(log,opt)

% export_waitbar - create export waitbar
% --------------------------------------
%
% h = export_waitbar(log,opt)
%
% Input:
% ------
%  log - log to be exported
%  opt - export options
%
% Output:
% -------
%  h - waitbar figure handle

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6335 $
% $Date: 2006-08-28 18:03:45 -0400 (Mon, 28 Aug 2006) $
%--------------------------------

%-------------------------------------------------
% DEFINE WAITBAR CONTROLS
%-------------------------------------------------

%--
% PROGRESS ('Exporting ...')
%--

% NOTE: progress header is provided by waitbar framework

control = control_create( ...
	'name','PROGRESS', ...
	'alias',['Exporting ' file_ext(log.file) ' ...'], ...
	'style','waitbar', ...
	'confirm',1, ...
	'update_rate',0.25, ...
	'lines',1.25, ...
	'space',1.5 ... 
);

%--
% close_confirm ('Close after completion')
%--

% NOTE: this value will be checked at the end of computation

control(end + 1) = control_create( ...
	'style','checkbox', ...
	'space',0.75, ...
	'value',1, ...
	'name','close_confirm', ... 
	'alias','Close after completion' ...
);

%-------------------------------------------------
% CREATE WAITBAR
%-------------------------------------------------

name = ['  Export Log ...'];

h = waitbar_group(name,control);

% palette_toggle(0,name,'Details','close');

