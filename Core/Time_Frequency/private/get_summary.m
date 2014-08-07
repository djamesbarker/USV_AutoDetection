function opt = get_summary(parameter)

% get_summary - get mex codes for summary options
% -----------------------------------------------
%
% opt = get_summary(parameter)
%
% Input:
% ------
%  parameter - spectrogram parameters
%
% Output:
% -------
%  opt - summary mex codes

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

%---------------------
% SUMMARY TYPE
%---------------------

sum_type = lower(parameter.sum_type);

switch (sum_type)

	case ({'mean','average'})
		opt.type = 0;

	case ('max')
		opt.type = 1;

	case ('min')
		opt.type = 2;

	case ('decimate')
		opt.type = 3;

	otherwise
		error(['Unknown summary type ''', sum_type, '''.']);

end

%---------------------
% SUMMARY LENGTH
%---------------------

opt.length = parameter.sum_length;

%---------------------
% SUMMARY QUALITY
%---------------------

% NOTE: the default quality value is coded in two places, here and create

if (isfield(parameter,'sum_quality'))
	sum_quality = lower(parameter.sum_quality);
else
	sum_quality = 'medium';
end

switch (sum_quality) 
	
	case ('low')
		opt.quality = 1;
		
	case ('medium')
		opt.quality = 2;
	
	case ('high')
		opt.quality = 3;
		
	case ('highest')
		opt.quality = 4;
		
	otherwise
		error(['Unknown summary quality ''', sum_quality, '''.']);
		
end
