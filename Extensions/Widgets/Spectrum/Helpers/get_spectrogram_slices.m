function [slice, ix] = get_spectrogram_slices(im, time)

% get_spectrogram_time_index - get index for times
% ------------------------------------------------
%
% [slice, ix] = get_spectrogram_slices(im, time)
%
% Input:
% ------
%  im - spectrogram image handle
%  time - time or time interval

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
% get spectrogram data
%--

X = get(im, 'cdata'); cols = size(X, 2); times = get(im, 'xdata');

%--
% handle time input
%--

% NOTE: if no selection criteria are proposed we get all slices

if (nargin < 2) || isempty(time)
	slice = X; ix = [1, cols]; return;
end

if length(time) > 2
	error('Time must be a single time or interval boundaries.');
end 

time = sort(time);

%--
% compute indices
%--

ix = round(cols * (time - times(1)) / diff(times));

% NOTE: in this case we don't want to infer start and end

if any(ix < 1) || any(ix > cols)
	slice = []; return;
end

%--
% get slices
%--

switch length(ix)
	
	case 1, slice = X(:, ix);
		
	case 2, slice = X(:, ix(1):ix(2));
		
end


