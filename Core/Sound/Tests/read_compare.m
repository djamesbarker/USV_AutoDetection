function out = read_compare(file, opt)

%--
% set / return options struct
%--

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

if ((nargin < 2) || isempty(opt))
	
	opt.trials = 5;
	
	opt.ch_read = 1;
	
	opt.compare = {'xbat_single', 'matlab_double'};
	
	opt.functions = {'xbat_single', 'xbat_double', 'matlab_single', 'matlab_double'};
	
	opt.length = 10^6; opt.channels = 1; opt.rate = 44100; opt.format = 'wav';
	
	if (~nargin)
		out = opt; return;
	end
	
end

%--
% generate source file if needed
%--

if ((nargin < 1) || isempty(file) || ~exist(file,'file'))
	file = generate_file(opt);
end

%--
% get list of formats writeable by XBAT
%--

if isempty(opt.formats)
	
	formats = get_writeable_formats;

else
	
	formats = [];
	
	for ix = 1:length(opt.formats)
		
		formats = [formats get_formats([], 'name', opt.formats{ix})];
		
	end
	
end
%--
% get samples from file
%--

opt_read = sound_file_read; 

X = sound_file_read(file, [], [], [], [1:opt.channels], opt_read);

%--
% create temp. file name
%--

temp_name = [fileparts(mfilename('fullpath')), filesep, 'temp'];

%--
% loop over formats, reading both single- and double-precision values, and 
% possibly comparing to built-in MATLAB functions
%--

for ix = 1:length(formats)
	
	%--
	% create temp_file name with appropriate extension and write samples to
	% it.
	%--
	
	disp(formats(ix).ext{1});
	
	temp_file = ['temp.', formats(ix).ext{1}];
	
	sound_file_write(temp_file,X,opt.rate);
	
	%--
	% now benchmark reading
	%--
	
	%--
	% loop over data classes
	%--
	
	for data_class = {'single', 'double'}
	
		opt_read.class = data_class{1};
	
		start = clock;
	
		for j = 1:opt.trials
			Y = sound_file_read(temp_file,0,length(X),[],[1:opt.ch_read],opt_read);
		end
	
		%--
		% get average elapsed time
		%--
		
		elapsed = etime(clock,start) / opt.trials;
	
		out(ix).(['xbat_' data_class{1}]) = numel(Y) / (elapsed * 10^6);
	
	end
	
	%--
	% if MATLAB has a reading utility for this format, bench it too
	%--
	
	% NOTE: this assumes that MATLAB sound read utilities are named: [ext]read.m
	% where [ext] is the file extension for that type of file, and that
	% they all work the same way as wavread.
	
	func_name = [formats(ix).ext{1} 'read'];
	
	if exist(func_name)
		
		func_handle = str2func(func_name);
		
		%--
		% double precision
		%--
		
		start = clock;
	
		for j = 1:opt.trials
			Y = func_handle(temp_file,length(X));
		end
		
		elapsed = etime(clock,start) / opt.trials;
		
		out(ix).matlab_double = numel(Y) / (elapsed * 10^6);
		
		%--
		% single precision
		%--
		
		start = clock;
	
		for j = 1:opt.trials
			Y = func_handle(temp_file,length(X));
			Y = single(Y);
		end
		
		elapsed = etime(clock,start) / opt.trials;
		
		out(ix).matlab_single = numel(Y) / (elapsed * 10^6);
		
	else
		
		%--
		% output NaNs for formats that MATLAB does not support
		%--
		
		out(ix).matlab_single = NaN;
		
		out(ix).matlab_double = NaN;
		
	end
	
end

%--
% sort bar graph x ticks by speed
%--

[garbage x] = sort([out.xbat_double]);

x = fliplr(x);

%--
% create bar plot using data specified in opt.compare
%--

y = zeros(length(opt.compare), length(formats));

for k = 1:length(opt.compare)
	
	yy = [out.(opt.compare{k})];
	
	y(k,:) = yy(x);
	
end

h = fig;

set(h, 'numbertitle', 'off', 'name', 'Sound Read Benchmark');

length(1:length(formats))

size(y', 1)

if (length(formats) > 1)

	h = bar(1:length(formats), y');
	
	%--
	% get legend names and create legend
	%--

	names = upper(opt.compare);

	names = strrep(names,'_DOUBLE',' (double)');
	names = strrep(names,'_SINGLE',' (single)');

	legend(h,names{:});

	%--
	% set labels and stuff
	%--

	temp = strfind(opt.compare, 'matlab');

	matlab_flag = ~isempty([temp{:}]);

	ax = gca;

	xt = cell(size(x));

	for k = x;

		ext = formats(x(k)).ext{1};

		label = upper(ext);

		%--
		% mark formats that are not supported in MATLAB
		%--

		if ~strcmpi(ext, {'wav', 'au'})
			if matlab_flag
				label = [label ' (*)'];
			end
		end

		xt{k} = label;

	end

	set(ax, 'XTickLabel', xt);	
	
else
	
	h = bar(y);
	
	ax = gca;
	
	names = upper(opt.compare);

	names = strrep(names,'_DOUBLE',' (double)');
	names = strrep(names,'_SINGLE',' (single)');
	
	set(ax, 'XTickLabel', names);
	
end

%--
% get label handles
%--

xlb = get(ax, 'XLabel');
ylb = get(ax, 'YLabel');
title = get(ax, 'Title');

%--
% write labels
%--

% if matlab_flag
% 	str = 'Format (*) = format not natively supported in MATLAB';
% else
% 	str = 'Format';
% end
% 
% set(xlb, 'String', str);

set(ylb, 'String', 'MS/SEC');

set(title, 'String', ['Sound File Read Speed (' num2str(opt.ch_read) ' out of ' num2str(opt.channels) ' channels)']); 




%--------------------------------------------------
% GENERATE_FILE
%--------------------------------------------------

function file = generate_file(opt)

%--
% generate file name and samples
%--

file = ['temp.', opt.format];

X = 2 * rand(opt.length,opt.channels) - 1;

%--
% write file
%--

sound_file_write(file,X,opt.rate);

	
	
	
	
