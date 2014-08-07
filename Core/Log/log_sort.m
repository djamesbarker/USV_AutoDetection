function Y = log_sort(X,field,d)

% log_sort - sort log events using specified field
% ------------------------------------------------
%
%  Y = log_sort(X,field,d)
%
% Input:
% ------
%  X - input log
%  field - event field used for sorting
%  d - sorting order, descending order -1 (def: 1)
%
% Output:
% -------
%  Y - sorted log

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% set sorting order
%--

if (nargin < 3)
	d = 1;
end

%--
% extract specified field
%--

if (isfield(X.event,field))
	F = struct_field(X.event,field);
else
	disp(' ');
	error(['Desired sorting field ''' field ''' is not an event field.']);
end

%--
% sort field and get indices
%--

[F,ix] = sortrows(F);

if (d == -1)
	ix = flipud(ix);
end

%--
% sort events and put in log
%--

Y = X;
Y.event = X.event(ix);
