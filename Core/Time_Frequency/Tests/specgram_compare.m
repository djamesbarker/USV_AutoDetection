function out = specgram_compare(param, opt)

% specgram_compare - compare several spectrogram computation options with bar chart
% -------------------------------------------------------------------------
% 
% opt = specgram_compare()
% out = specgram_compare(param, opt)
%
% Input:
% ------
% param - spectrogram paramter structure
% opt   - configuration options, defaults generated
%
% Output:
% -------
% out - structure array of scalar performance metrics
% opt - default configurations structure
%

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
% Author: Matt Robbins
%--------------------------------
% $Revision: 3512 $
% $Date: 2006-02-13 17:19:46 -0500 (Mon, 13 Feb 2006) $
%--------------------------------


%--
% configure options structure with defaults
%--

if (nargin < 2 || isempty(opt))
	
	opt.samples = 10000000;
	
	opt.rate = 44100;
	
	opt.measure = 'x_realtime';
	
	opt.compare = {'xbat_single', 'xbat_double'};
	
	out = opt; return;
	
end

%--
% get default spectrogram parameters if none are specified
%--

if (isempty(param))
	
	param = specgram_parameter;
	
end

%--
% generate test signal
%--

X = generate_signal(opt);

%--
% iterate over functions to compare
%--

measure_handle = str2func(opt.measure);

for func_name = opt.compare
	
	func_handle = str2func(func_name{1});
		
	%--
	% time spectrogram computation
	%--
	
	[B, t] = func_handle(X, param);
	
	out.(func_name{1}) = measure_handle(t, opt);
	
end

%--
% create bar plot using data specified in opt.compare
%--

y = [];

for k = opt.compare
	
	y = [y ; out.(k{1})];
	
end

fig;

h = bar(y, .4);

ax = gca;

set(ax, 'XTickLabel', title_caps(opt.compare));

ylabel_str = ['speed: (' title_caps(opt.measure) ')'];

if strcmp(opt.measure, 'x_realtime')
	
	ylabel_str = [ylabel_str ' (at ', num2str(opt.rate), ' Hz Sample Rate)'];
	
end

ylabel(ylabel_str);

xlabel('Computation Function');

title_str = {'Spectrogram Speed Comparison: ', ...
 	['FFT size = ', num2str(param.fft), ' samples'], ...
	['Overlap = ', num2str(floor(param.hop*param.fft)), ' samples'], ...
	['Window Length = ', num2str(floor(param.win_length*param.fft)), ' samples'] ...
};

Title(title_str);
	
	
%-------------------------------------
% XBAT_SINGLE
%-------------------------------------

function [B, t] = xbat_single(X, param)

X = single(X);

[B, t] = xbat_double(X, param);

B = double(B);


%-------------------------------------
% XBAT_DOUBLE
%-------------------------------------

function [B, t] = xbat_double(X, param)

tic;

B = fast_specgram(X, [], [], param);

t = toc;


%-------------------------------------
% MATLAB_DOUBLE
%-------------------------------------

function [B, t] = matlab_double(X, param)

%--
% extract parameters
%--

fn = param.fft;

overlap = round(fn * (1 - param.hop));

hn = round(fn * param.win_length); 

%--
% generate window
%--

if (isempty(window_to_fun(param.win_type,'param')))
	h = feval(window_to_fun(param.win_type),hn);
else
	h = feval(window_to_fun(param.win_type),hn,param.win_param);
end

% NOTE: zero pad window to fft length if needed

if (hn < fn)
	h((hn + 1):fn) = 0; hn = fn;
end 

%--
% compute spectrogram and time
%--

tic;

B = spectrogram(X, h, overlap, fn);

t = toc;


%--------------------------------------
% MATLAB_SINGLE
%--------------------------------------

function [B, t] = matlab_single(X, param)

[B, t] = matlab_double(X, param);

	
%--------------------------------------
% XREALTIME
%--------------------------------------

function x = x_realtime(t, opt)

actual_time = opt.samples / opt.rate;

x = actual_time / t;


%--------------------------------------
% MSPS
%--------------------------------------

function x = msps(t, opt)

x = (opt.samples / t) / 10^6;


%--------------------------------------
% GENERATE_SIGNAL
%--------------------------------------

function x = generate_signal(opt)

x = randn(opt.samples, 1);
