function [X, rate, B, freq] = get_model_signal(data, context, rate)

% get_model_signal - create synthetic signal using model
% ------------------------------------------------------
%
% [X, rate] = get_model_signal(data, context, rate)
%
% Input:
% ------
%  data - explain data
%  context - extension context
%  rate - signal rate
%
% Output:
% -------
%  X - model signal
%  rate - signal rate
  
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

% TODO: consider alignment of generated signals, and multiple channels

% TODO: improve and document spectrogram generation

%--------------------
% HANDLE INPUT
%--------------------

%--
% get default rate from context sound
%--

if (nargin < 3)
	rate = get_sound_rate(context.sound);
end

%--------------------
% MODEL SIGNAL
%--------------------

%--
% initalize signal
%--

N = round(diff(data.time) * rate);

X = zeros(1, N);

%--
% compose signal
%--

for k = 1:length(data.component)
	
	%--
	% get and add model component if needed
	%--
	
	[Xk, ix] = get_component_signal(data, k, rate);
	
	if ~isempty(Xk)
		X(ix) = X(ix) + Xk;
	end
		
end

% HACK: this is to resolve a clipping problem in the save to file

% NOTE: the synthesis typically is very close to the limit and simple normalization does not work

A = max(abs(X)) + 0.1;

if A > 1
	X = X ./ A;
end

%--
% compute spectrogram if needed
%--

if (nargout > 2)
	[B, freq] = fast_specgram(X', [], 'power', context.sound.specgram);
end
