function out = bench_sound(format,file,opt)

% bench_sound - test sound access performance
% -------------------------------------------
%
% out = bench_sound(format,file,opt)
%
% Input:
% ------
%  format - formats to bench
%  file - sound file
%  opt - options
%
% Output:
% -------
%  out - results

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

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

%--
% set possibly return default options
%--

if ((nargin < 3) || isempty(opt))
	
	opt.trials = 2;
	
	opt.length = 10^4; opt.rate = 44100; opt.format = 'wav';
	
	if (~nargin)
		out = opt; return;
	end
	
end

%--
% generate source file if needed
%--

if ((nargin < 2) || isempty(file) || ~exist(file,'file'))
	file = generate_file(opt);
end

%--
% get or check writeable formats
%--

if ((nargin < 1) || isempty(format))
	format = get_formats;
end

format = get_writeable_formats(format);

%-----------------------------------------
% BENCHMARK
%-----------------------------------------

opt_read = sound_file_read; 

%--
% get samples from file
%--

X = sound_file_read(file);

%--
% generate temp name
%--

temp_name = [fileparts(mfilename('fullpath')), filesep, 'temp'];

%--
% loop over formats to test write and read
%--

for k = 1:length(format)
	
	out(k).ext = format(k).name;
	
	temp_file = [temp_name, '.', format(k).ext{1}];
	
	%--
	% write file
	%--
	
	start = clock;
	
	for j = 1:opt.trials
		sound_file_write(temp_file,X,opt.rate);
	end
	
	elapsed = etime(clock,start) / opt.trials;
	
	out(k).write.size = size(X); 
	
	out(k).write.rate = numel(X) / (elapsed * 10^6);
	
	%--
	% read file
	%--
	
	start = clock;
	
	for j = 1:opt.trials
		Y = sound_file_read(temp_file,0,length(X),[],1,opt_read);
	end
	
	elapsed = etime(clock,start) / opt.trials;
	
	out(k).read.size = size(Y); 
	
	out(k).read.rate = numel(Y) / (elapsed * 10^6);
	
	try
		fig; plot(X); hold on; plot(Y,'r');
		
		out(k).error = max(abs(Y - X));
	catch
		out(k).error = lasterror;
	end
	
end


%--------------------------------------------------
% GENERATE_FILE
%--------------------------------------------------

function file = generate_file(opt)

%--
% generate file name and samples
%--

file = [tempname, '.', opt.format];

X = 2 * rand(opt.length,1) - 1; 

%--
% write file
%--

sound_file_write(file,X,opt.rate);


