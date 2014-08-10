function [low, high] = frequency_guides(ax, varargin)

% NOTE: we force the linestyle by including it last

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

low = create_line(ax, 'low_freq_guide', varargin{:}, 'linestyle', ':');

high = create_line(ax, 'high_freq_guide', varargin{:}, 'linestyle', ':');

if nargout < 2
	low = [low, high];
end
