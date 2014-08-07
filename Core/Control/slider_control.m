function control = slider_control(name, varargin)

%--
% check name and alias input
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

% TODO: factor this so that all helpers can use it

if ~ischar(name) && ~(iscellstr(name) && (length(name) == 2))
	error('Name input must be a string or a cell array of strings of length 2.'); 
end

if iscell(name)
	alias = name{2}; name = name{1};
else
	alias = '';
end

%--
% handle various calling forms
%--

if (length(varargin) == 1)

	%--
	% sequence input
	%--
	
	seq = sort(varargin{1});

	mini = seq(1); maxi = seq(end); value = 0.5 * (mini + maxi);
	
	integer = all(floor(seq) == seq) && all(diff(seq) == 1)
	
	if integer
		value = max(mini, floor(value));
	end
	
	inc = diff(seq); range = maxi - mini;
	
	if (max(inc) - min(inc) < 10^-4 * range)
		slider_inc = inc(1) * [1, 2];
	end

else

	%--
	% min and max input
	%--
	
	mini = varargin{1}; maxi = varargin{2};

	if (maxi <= mini)
		error('Slider max must exceed min.');
	end
		
	%--
	% value input
	%--
	
	value = varargin{3};

	if (value < mini) || (value > maxi)
		error('Slider value must be between min and max values.');
	end

end

%--
% create control using provided information
%--

control = control_create( ...
	'style', 'slider', ...
	'name', name, ...
	'alias', alias, ...
	'min', mini, ...
	'max', maxi, ...
	'value', value ...
);

%--
% add slider type information
%--

if exist('integer', 'var') && integer
	control.type = 'integer';
end

if exist('time', 'var') && time
	control.type = 'time';
end

%--
% add slider increment information
%--

if exist('slider_inc', 'var')
	control.slider_inc = slider_inc;
end 

