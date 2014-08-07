function log_export(ff)

% log_export - export log information to text file
% ------------------------------------------------
%
% log_export(ff)
%
% Input:
% ------
%  ff - filename format descriptor (def: '*_yyyylldd_hhmmss')
%
% Notes:
% ------
%  1. Another common filename format is described as 'yylldd_hhmmss'.
%     Example filenames for the two descriptors are:
%
%     '*_yyyylldd_hhmmss' -> ID5_20010314_203412.aif -> March 14,2001 20:34:12
%     'yylldd_hhmmss' -> 010105_034512.wav -> January 5,2001 03:45:12
%
%  2. The exported location is the top location in the array of saved locations.

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
% set filename format string
%--

if (nargin < 1)
	ff = '*_yyyylldd_hhmmss';
end

%--
% simple check on format string and get data indices
%--

if (ff(1) == '*')
	
	flag_name = 1;
	if (isletter(ff(2)))
		disp(' ');
		error('Missing non-alphabetic separator.');
	else
		sep = ff(2);
	end
	
	ff = ff(3:end);
	
else
	
	flag_name = 0;
	
	ptr = find(~isletter(ff));
	if (~isempty(ptr))
		sep = ff(ptr(1));
	else
		disp(' ');
		error('Missing non-alphabetic separator.');
	end
	
end

c = {'y','l','d','h','m','s'};

ix{1} = findstr(ff,'y');
if ((length(ix{1}) ~= 2) & (length(ix{1}) ~= 4))
	disp(' ');
	error('Improper filename descriptor.');
end

for k = 2:length(c)
	ix{k} = findstr(ff,c{k});
	if (length(ix{k}) ~= 2)
		disp(' ');
		error('Improper filename descriptor.');
	end
end

%--
% open log file and load variables
%--

if (nargin < 2)
	
	%--
	% open log file
	%--
	
	try
		[fn_in,p_in] = uigetfile2('*.mat','Select log file to export:');
		tmp = load([p_in,fn_in]);
	catch
		disp(' ');
		warning('Get log file was cancelled.');
	end
	
	%--
	% get variables
	%--
	
	try 
		geom = tmp.arrGeom;
		sound = tmp.fileList;
		log = tmp.output;
		new_log = tmp.new_log;
	catch
		disp(' ');
		error('File does not contain needed log variables.');
	end
	
end

%--
% select output file location
%--

tmp = findstr(fn_in,'.'); 
fn = fn_in(1:tmp(end) - 1);
name = [p_in, fn, '.txt'];

[fn,p] = uiputfile( ...
	name, ...
	'Choose location of output text file:' ...
);

%--
% create and open output text file
%--

try
	fid = fopen([p,fn],'w');
catch
	disp(' ')
	error('Problems creating output file.');
end

%--
% produce tab delimited text table output of log
%--

%--
% log file information
%--

fprintf(fid,'Log File - %s\n',fn_in);
fprintf(fid,'Log Path - %s\n',p);
fprintf(fid,'Export Date - %s\n\n',datestr(now));

%--
% array geometry
%--

if (isempty(geom))
	fprintf(fid,'Array Geometry not present\n\n');
else
	fprintf(fid,'Array Geometry\t %d\n',size(geom,1)); 
	for n = 1:size(geom,1)
		fprintf(fid,'%0.4f \t %0.4f\n',geom(n,1),geom(n,2));
	end
	fprintf(fid,'\n');
end

%--
% events, locations, and measurements
%--

fprintf(fid,'Log Events\n');

% table headings

fprintf(fid, ...
	['Index\t Filename\t Channel\t Date\t Time\t Duration (s)\t ' ...
	'Min Freq (Hz)\t Max Freq (Hz)\t X Loc\t Y Loc\t Z Loc\t Class\t'] ...
);  

for k = 1:(sound.channels - 1)
	fprintf(fid,['RL ' num2str(k) '\t']);
end

fprintf(fid,['RL ' num2str(sound.channels) '\n']);

%--
% compute group cumulative times
%--

group_time = [0; sound.samples / sound.samplerate];

%--
% loop over events in log file
%--

% create waitbar

hw = waitbar(0);
set(hw,'name',['Log Export - ' fn_in]);

for k = 1:size(log,1)
	
	%--
	% check that log contains classifications
	%--
	
	if (size(log,2) >= 6)
		
		%--
		% check that log contains locations
		%--
		
		if (size(log,2) >= 7)
			loc = log{k,7};
		else
			loc = [];
		end
		
		classCode = log{k,6};
		
		if (isempty(classCode) == 1)
			classCode = '';
		end
		
		%--
		% truncate class codes to 30 characters
		%--
		
% 		if (length(classCode) > 30)
%             classCode = classCode(1:30);
%    	end
		
	%--
	% set empty classifications and locations
	%--
	
	else
		
		loc = [];
		classCode = '';
		
	end
	
	%--
	% compute real event time for export
	%--
				
	%--
	% look up event file index using event time from start of group
	%--
	
	time = log{k,1}(1);
	
	file_ix = find(group_time > time);
	file_ix = file_ix(1) - 1;
	
	%--
	% parse filename to get date and start time of file
	%--

	% these should be the same
	
% 	file = strtok(sound.file{file_ix},'.'); 
	file = strtok(log{k,3},'.');
	
	if (flag_name)
		ptr = findstr(file,sep);
		tmp = file((ptr(1) + 1):end);
		date = [tmp(ix{1}),tmp(ix{2}),tmp(ix{3})];
		time_str = [tmp(ix{4}),tmp(ix{5}),tmp(ix{6})];
	else
		tmp = file;
		if (length(ix{1}) < 4)
			date = ['20',tmp(ix{1}),tmp(ix{2}),tmp(ix{3})];
		else
			date = [tmp(ix{1}),tmp(ix{2}),tmp(ix{3})];
		end
		time_str = [tmp(ix{4}),tmp(ix{5}),tmp(ix{6})];
	end
	
	file_clock = [time_str(1:2) ':' time_str(3:4) ':' time_str(5:6)];
	file_date = datestr(datenum([str2num(date(1:4)),str2num(date(5:6)),str2num(date(7:8))]));
	
	%--
	% get time from start of file
	%--
	
	event_time = time - group_time(file_ix);
	
	% update event time based on file start time

	event_clock = sec_to_clock(round(clock_to_sec(file_clock) + event_time));
	
	% update date and time if day boundary is crossed
	
	tmp = str2num(strtok(event_clock,':'));
	if (tmp > 24)
		event_clock(1:2) = num2str(mod(tmp,24));
		date(3) = date(3) + 1;
		file_date = datestr(datenum(date));
	end
				
	%--
	% output event table rows
	%--
	
	%--
	% check for non-empty location information
	%--
	
	if (isempty(loc))

		% index, filename, channel, date, time, duration, 
		% min freq, max freq, x loc, y loc, z loc, level, class
		
		%--
		% check for receive level information
		%--
		
		if (size(log,2) >= 10)
						
			fprintf(fid,['%d\t %s\t %d\t %s\t %s\t %0.4f\t %0.4f\t %0.4f\t \t \t \t %s\t'], ...
				k, ...
				log{k,3}, log{k,4}, ...
				file_date, event_clock, log{k,1}(2), ...
				log{k,2}(1), log{k,2}(2), ...
				classCode ...
			);
				
			if (~isempty(log{k,10}))
				for i = 1:(sound.channels - 1)
					fprintf(fid,'%0.4f\t',log{k,10}(i));
				end
				fprintf(fid,'%0.4f\n',log{k,10}(end));
			else
				for i = 1:(sound.channels - 1)
					fprintf(fid,'\t');
				end
				fprintf(fid,'\n');
			end
			
		else
			
			fprintf(fid,'%d\t %s\t %d\t %s\t %s\t %0.4f\t %0.4f\t %0.4f\t \t \t %s\t', ...
				k, ...
				log{k,3}, log{k,4}, ...
				file_date, event_clock, log{k,1}(2), ...
				log{k,2}(1), log{k,2}(2), ...
				classCode ...
			);
						
			for i = 1:(sound.channels - 1)
				fprintf(fid,'\t');
			end
			fprintf(fid,'\n');
			
		end
		
	else  
		
		% index, filename, channel, date, time, duration, 
		% min freq, max freq, x loc, y loc, z loc, level, class
		
		if (size(log,2) >= 10)
			
			fprintf(fid,'%d\t %s\t %d\t %s\t %s\t %0.4f\t %0.4f\t %0.4f\t %0.4f\t %0.4f\t %0.4f\t %s\t', ...
				k, ...
				log{k,3}, log{k,4}, ...
				file_date, event_clock, log{k,1}(2), ...
				log{k,2}(1), log{k,2}(2), ...
				loc(1,1), loc(1,2), loc(1,3), ...
				classCode ...
			);
			
			if (~isempty(log{k,10}))
				for i = 1:(sound.channels - 1)
					fprintf(fid,'%0.4f\t',log{k,10}(i));
				end
				fprintf(fid,'%0.4f\n',log{k,10}(end));
			else
				for i = 1:(sound.channels - 1)
					fprintf(fid,'\t');
				end
				fprintf(fid,'\n');
			end
			
		else
			
			fprintf(fid,'%d\t %s\t %d\t %s\t %s\t %0.4f\t %0.4f\t %0.4f\t %0.4f\t %0.4f\t %0.4f\t %s\t', ...
				k, ...
				log{k,3}, log{k,4}, ...
				file_date, event_clock, log{k,1}(2), ...
				log{k,2}(1), log{k,2}(2), ...
				loc(1,1), loc(1,2), loc(1,3), ...
				classCode ...
			);
			
			for i = 1:(sound.channels - 1)
				fprintf(fid,'\t');
			end
			
			fprintf(fid,'\n');
			
		end
		
	end
	
	%--
	% update waitbar
	%--
	
	waitbar(k/size(log,1),hw,['Events exported: ' num2str(k)]);
	
end

%--
% close output file
%--

fclose(fid);   

%--
% close waitbar
%--

close(hw);

%--
% AUXILIARY FUNCTIONS
%--

function t = clock_to_sec(str)

% clock_to_sec - convert time string to seconds
% ---------------------------------------------
%
% t = clock_to_sec(str)
%
% Input:
% ------
%  str - clock time strings
%
% Output:
% -------
%  t - times in seconds

%--
% loop over time strings
%--

if (iscell(str))
	t = zeros(size(str));
else
	str = {str};
	t = 0;
end

for k = 1:(prod(size(t)))
	
	tmp = str{k};
	ix = findstr(tmp,':');
	
	t(k) = ...
		3600 * str2num(tmp(1:(ix(1) - 1))) + ...
		60 * str2num(tmp((ix(1) + 1):(ix(2) - 1))) + ...
		str2num(tmp((ix(2) + 1):end));
	
end

function str = sec_to_clock(t,n)

% sec_to_clock - convert seconds to time string
% ---------------------------------------------
%
% str = sec_to_clock(t,n)
%
% Input:
% ------
%  t - time in seconds
%  n - fractional second digits (def: 2)
%
% Output:
% -------
%  str - time string

%--
% set precision
%--

if (nargin < 2)
	n = 2;
end

%--
% compute hours, minutes, and seconds
%--

% put time in column form

t = t(:);
h = floor(floor(t) ./ 3600);

t = t - (h * 3600);
m = floor(floor(t) ./ 60);

s = t - (m * 60);

%--
% build time string
%--
		
% convert hours to strings

str1 = cellstr(int2str(h));	

% convert minutes to strings pad if less than 10

ixm = find(m < 10);

if (length(ixm))
	str2 = cellstr(int2str(m));
	str2(ixm) = strcat('0',str2(ixm)); 
else
	str2 = cellstr(int2str(m));
end

% convert seconds to strings, note the different precision settings

ixs = find(s < 10);

if (length(ixs))	
	str3 = cellstr(num2str(s,n + 1));
	str3(ixs) = strcat('0',str3(ixs));
else
	str3 = cellstr(num2str(s,n + 2));
end

% compose full time string

str = strcat(str1,':',str2,':',str3);
str = strrep(str,' ','');

%--
% output string
%--

if (length(str) == 1)
	str = str{1};
end


