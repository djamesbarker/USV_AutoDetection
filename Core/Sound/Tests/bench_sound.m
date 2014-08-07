function B = bench_sound

% TODO: bench sound writing as well

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
% CONSTANTS
%-----------------------------------------

NTRIALS = 3;

FNAME = 'test';

FLENGTH = 1000000;

NCH = 2;

RATE = 44100;

SAMPLES = 2*rand(FLENGTH, NCH)-1;

%-----------------------------------------
% RUN BENCHMARK
%-----------------------------------------


%-----------------------------------------
% COMPARE ALL SOUND_FILE_READ FORMATS
%-----------------------------------------

f = get_writeable_formats;

%--
% start off with big time vector
%--

t = inf*ones(1, length(f));

%--
% loop over formats
%--

disp(['@' func2str(@sound_file_read)]);

for ix = 1:length(f)
		
	disp(f(ix).ext{1})
	
	%--
	% get absolute file path and write test sound
	%--
	
	p = fileparts(which(mfilename));
		
	floc = [p filesep FNAME '.' f(ix).ext{1}]
		
	sound_file_write(floc, SAMPLES, RATE);
	
	%--
	% read N times and take the minimum time
	%--

	for jx = 1:NTRIALS
		
		x = [];
		
		tic;
		
		x = sound_file_read(floc);
		
		tm = toc;
		
		t(ix) = min([t(ix), tm]);
			
	end
	
end

%--------------------------------------------
% COMPARE TO BUILT-IN MATLAB FUNCTIONS
%--------------------------------------------

funcs = {@auread, @wavread};

ix = length(t) + 1;

t(ix:ix+length(funcs)-1) = inf;

for kx = 1:length(funcs)
	
	for jx = 1:NTRIALS
		
		x = [];
		
		tic;
		
		x = funcs{kx}(FNAME);
		
		tm = toc;
		
		t(ix) = min([t(ix), tm]);
		
	end
	
	%--
	% make up phony "format" with <extension name> = <built-in function
	% name>
	%--
	
	f(ix) = f(ix-1);
	
	f(ix).ext{1} = ['@' func2str(funcs{kx})];
	
	disp(f(ix).ext{1});
	
	ix = ix + 1;
	
end

%--------------------------------------------------
% COMPUTE MS/S AND RETURN
%--------------------------------------------------

nsamples = FLENGTH*NCH;

r = nsamples./(t*10^6);

b = cell(0);

for qx = 1:length(f)
	
	b{qx} = struct('ext', f(qx).ext{1}, 'rate', r(qx));
	
end

B = b';




