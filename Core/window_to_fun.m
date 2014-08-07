function [fun, S, ix] = window_to_fun(str, out)

% window_to_fun - get function for named window
% ---------------------------------------------
%
% [fun, S, ix] = window_to_fun(str)
%
%    param = window_to_fun(str, 'param')
%
% Input:
% ------
%  str - window name
%
% Output:
% -------
%  fun - function name or list of available functions
%  S - suggested menu separators
%  ix - default index into list

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

% TODO: check for availability of signal processing toolbox

% NOTE: consider replacing windows altogether, this will not resolve the
% filtering dependencies, and will introduce discrepancies betweeen toolbox
% and non-toolbox window functions in some cases?

%--
% set output mode
%--

if (nargin < 2) || isempty(out)
	out = 'name';
end

ix = [];

%--
% create window function table
%--

persistent WINDOW_FUN_TABLE;
	
if isempty(WINDOW_FUN_TABLE)
	
	%--
	% create window function and parameters table
	%--
	
	if has_toolbox('signal')
		
		WINDOW_FUN_TABLE = { ...
			'Bartlett', @bartlett, []; ...
			'Bartlett-Hanning', @barthannwin, []; ...
			'Blackman', @blackman, []; ...
			'Blackman-Harris', @blackmanharris, []; ...
			'Bohman', @bohmanwin, []; ...
			'Chebyshev', @chebwin, {'R', 'Sidelobe attenuation in dB', [100, 500], 100};
			'Flattop', @flattopwin, []; ...
			'Gaussian', @gausswin, {'Alpha', 'Reciprocal standard deviation', [0, 5], 2.5}; ...
			'Hamming', @hamming, []; ...
			'Hann', @hann, []; ...
			'Kaiser', @kaiser, {'Beta', 'Bessel function parameter', [0, 20], 7}; ...
			'Nutall', @nuttallwin, []; ...
			'Parzen', @parzenwin, [];
			'Rectangular', @rectwin, []; ...
			'Triangular', @triang, []; ...
			'Tukey', @tukeywin, {'R', 'Hanning-Rectangular mix coefficient', [0, 1], 0.5} ...
		};

	else
		
		WINDOW_FUN_TABLE = { ...
			'Blackman', @blackman_window, []; ...
			'Blackman-Nuttall', @blackman_nuttall_window, []; ...
			'Hamming', @hamming_window, []; ...
			'Hann', @hann_window, []; ...
			'Rectangular', @rectangular_window, []; ...
			'Triangular', @triangular_window, []; ...
		};

	end
	
	%--
	% convert table parameter representation to structure
	%--

	% NOTE: why is this done this way ???
	
	for k = 1:size(WINDOW_FUN_TABLE, 1)

		if ~isempty(WINDOW_FUN_TABLE{k, 3})

			tmp.name = WINDOW_FUN_TABLE{k, 3}{1};
			tmp.tip = WINDOW_FUN_TABLE{k, 3}{2};
			tmp.min = WINDOW_FUN_TABLE{k, 3}{3}(1);
			tmp.max = WINDOW_FUN_TABLE{k, 3}{3}(2);
			tmp.value = WINDOW_FUN_TABLE{k, 3}{4};

			WINDOW_FUN_TABLE{k, 3} = tmp;

		end

	end

end
		
%--
% look up function name or parameter description
%--

if nargin
	
	switch out
		
		%--
		% output window function handle
		%--
		
		case 'name'
			
			ix = find(strcmpi(str, WINDOW_FUN_TABLE(:, 1)));
			
			if ~isempty(ix)
				fun = WINDOW_FUN_TABLE{ix, 2};
			else
				fun = [];
			end
			
		%--
		% output window function parameter description
		%--
		
		case 'param'
			
			ix = find(strcmpi(str, WINDOW_FUN_TABLE(:, 1)));
		
			if ~isempty(ix)
				fun = WINDOW_FUN_TABLE{ix, 3};
			else
				fun = [];
			end
			
		%--
		% error
		%--
		
		otherwise, error(['Unrecognized output mode ''', out, '''.']);
			
	end

%--
% output available window names
%--

else
	
	%--
	% output list of available windows
	%--
	
	fun = WINDOW_FUN_TABLE(:, 1);
	
	%--
	% output menu separators
	%--
	
	% NOTE: the separators are not needed
	
	if nargout > 1
		n = length(fun); S = bin2str(zeros(1, n));
	end
	
	if nargout > 2
		
		ix = find(strcmpi(fun, 'hann')); 
		
		if isempty(ix)
			ix = 1;
		end
		
	end
	
end


%------------------------------------
% WINDOW FUNCTIONS
%------------------------------------

function h = blackman_window(N)

h = some_windows(N, 'blackman');


function h = blackman_nuttall_window(N)

h = some_windows(N, 'blackman-nuttall');


function h = hamming_window(N)

h = some_windows(N, 'hamming');


function h = hann_window(N)

h = some_windows(N, 'hann');


function h = rectangular_window(N)

h = some_windows(N, 'rectangular');


function h = triangular_window(N)

h = some_windows(N, 'triangular');


%------------------------------------
% SOME_WINDOWS
%------------------------------------

% NOTE: these windows will not be perfectly interchangeable with MATLAB windows

function h = some_windows(N, name, varargin)

% REF: http://en.wikipedia.org/wiki/Window_function

%--
% set trigonometric evaluation grid
%--

n = linspace(0, 2*pi, N + 1);

%--
% build window by name
%--

switch lower(name) 
		
	case 'blackman'
		h = 0.42 - 0.5 * cos(n) + 0.08 * cos(2 * n);
		
	case 'blackman-nuttall'
		h = 0.3635819 - 0.4891775 * cos(n) + 0.1365995 * cos(2 * n) - 0.0106411 * cos(3 * n);
		
	case 'hamming'
		h = 0.53836 - 0.46164 * cos(n); % 0.54, 0.46 in MATLAB implementation
		
	case 'hann'
		h = 0.5 * (1 - cos(n)); 
	
	case 'rectangular'
		h = ones(1, N + 1);
		
	case 'triangular'
		h = 1 - abs(linspace(-1, 1, N + 1)); 
		
end

%--
% enforce periodicity
%--

h(end) = [];
