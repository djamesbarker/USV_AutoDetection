function B = bench_specgram

% TODO: parametrize test

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

funcs = { ...

	struct('name', 'xbat_double', 'handle', @xbat_double), ...
	struct('name', 'xbat_double_new', 'handle', @xbat_double_new) ...
	
};
% struct('name', 'signal_double', 'handle', @signal_double), ...
% struct('name', 'xbat_float', 'handle', @xbat_float) ...

NLENS = 10;
MAXLEN = 100000;

NTRIALS = 10;

% NFFT = 512;
WIN = hanning(256);
OLAP = 10;

MODE = 'cpx';

lengths = (1:NLENS)*(MAXLEN/NLENS);

	
nfuncs = length(funcs);

B = cell(4, nfuncs);

for ix = 1:nfuncs
	B{4, ix} = zeros(1, NLENS);
end

nffts = better_fft_sizes(256, 2048);

lix = 1;

L = 100000;

for NFFT = nffts'
	
	disp(['testing ' num2str(NFFT) ' points...']);
	
	sig = randn(L, 1);
	
	for ix = 1:nfuncs
	
		disp(['   ' funcs{ix}.name '...']);
		
		B{2, ix} = zeros(1, NTRIALS);
		
		
		for jx = 1:NTRIALS
		
			tic;

			B{1, ix} = funcs{ix}.handle(sig, WIN, NFFT, OLAP, MODE);

			t = toc;
			
			B{2, ix}(jx) = t; 
					
		end
		
		mt = double(median(B{2, ix}));
		
		B{4, ix}(lix) = mt;	
		
		disp(['      average time = ', num2str(mt), ' seconds.']);
		
		err = mean(mean(abs(B{1, ix}-B{1, 1})));
		
		B{3, ix} = err;
		
		disp(['       average error = ', num2str(err)]);
		
	end
	
	lix = lix + 1;

end
	
fig;

times = zeros(length(nffts), nfuncs);

names = cell(1, nfuncs);

for ix = 1:nfuncs
	times(:,ix) = B{4, ix};
	names{ix} = funcs{ix}.name;
end


plot(nffts, times);
xlabel('fft length (samples)');
ylabel('execution time (seconds)');

names{:}; legend(names{:});


%------------------------------------
% XBAT_DOUBLE
%------------------------------------
		
function [B] = xbat_double_new(sig, WIN, NFFT, OLAP, MODE)

switch MODE

	case {'cpx', 'complex'}
		B = fast_specgram_mexs(sig, WIN, NFFT, OLAP, 2);
	case {'pwr', 'power'}
		B = fast_specgram_mexs(sig, WIN, NFFT, OLAP, 1);
	case {'nrm', 'norm', 'abs'}
		B = fast_specgram_mexs(sig, WIN, NFFT, OLAP, 0);
	otherwise
		error('unknown computation option');
		
end

function [B] = xbat_double(sig, WIN, NFFT, OLAP, MODE)

switch MODE

	case {'cpx', 'complex'}
		B = fast_specgram_mex(sig, WIN, NFFT, OLAP, 2);
	case {'pwr', 'power'}
		B = fast_specgram_mex(sig, WIN, NFFT, OLAP, 1);
	case {'nrm', 'norm', 'abs'}
		B = fast_specgram_mex(sig, WIN, NFFT, OLAP, 0);
	otherwise
		error('unknown computation option');
		
end


%------------------------------------
% XBAT_FLOAT
%------------------------------------

function [B] = xbat_float(sig, WIN, NFFT, OLAP, MODE)

sig = single(sig); WIN = single(WIN);

switch MODE

	case {'cpx', 'complex'}
		B = fast_specgram_mexf(sig, WIN, NFFT, OLAP, 2);
	case {'pwr', 'power'}
		B = fast_specgram_mexf(sig, WIN, NFFT, OLAP, 1);
	case {'nrm', 'norm', 'abs'}
		B = fast_specgram_mexf(sig, WIN, NFFT, OLAP, 0);
	otherwise
		error('unknown computation option');
		
end


%------------------------------------
% SIGNAL_DOUBLE
%------------------------------------

% NOTE: this computes using the signal processing toolbox function

function [B] = signal_double(sig, WIN, NFFT, OLAP, MODE)

switch MODE
	
	case {'cpx', 'complex'}
		B = specgram(sig, NFFT, 2, WIN, OLAP);
	case {'pwr', 'power'}
		B = specgram(sig, NFFT, 2, WIN, OLAP); B = B.^conj(B);
	case {'nrm', 'norm', 'abs'}
		B = specgram(fun(sig, NFFT, 2, WIN, OLAP));
	otherwise
		error('unknown computation option');
		
end



