function value = round_to_order(value, digits)

% round_to_order - round to get order of magnitude number
% -------------------------------------------------------
%
% value = round_to_order(value, digits)
%
% Input:
% ------
%  value - to round
%  digits - in order
%
% Output:
% -------
%  value - rounded to order

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

% TODO: extend to handle arrays using 'max' and 'each' modes

%--
% handle input
%--

if nargin < 2
    if value > 0 
        digits = floor(log10(value));
    else
        digits = 1;
    end
end

if digits < 1
	return;
end

%--
% round
%--

factor = 10^(digits - 1);

value = factor * round(value / factor);
