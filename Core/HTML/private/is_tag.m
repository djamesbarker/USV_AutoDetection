function value = is_tag(in)

% is_tag - test whether input is tag
% -----------------------------------
%
% value = is_tag(in)
%
% Input:
% ------
%  in - input to test
%
% Output:
% -------
%  value - tag indicator

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
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%--
% set tag fields
%--

fields = {'open', 'close'};

%--
% test for struct with proper fields
%--

% NOTE: we disregard field order in this test

value = isstruct(in) && isempty(setdiff(fieldnames(in), fields));
